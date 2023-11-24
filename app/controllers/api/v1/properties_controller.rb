class Api::V1::PropertiesController < Api::V1::ApiController
  require 'uri'

  before_action :validate_property_type, only: [:update, :create, :property_filters]
  before_action :set_property_params, only: [:update, :create]
  before_action :check_number_of_images, only: [:update, :create]
  before_action :set_property, only: [:show, :update, :destroy]

  def index
    @properties = @current_user.properties.order("created_at desc")
  end

  def show; end # this is here for a reason, do not delete!

  def create
    @property = @property_params[:property_type].titleize.gsub(" ", "").constantize.new(@property_params)
    @property.user = @current_user
    if @property.save
      @property
    else
      render_error_messages(@property)
    end
  end

  def update
    @property.type = @property_params[:property_type].titleize.gsub(" ", "").constantize
    if @property.update(@image_arr.length > 0 ? @property_params : @property_params.except(:images))
      @property
    else
      render_error_messages(@property)
    end
  end

  def destroy
    if @property.destroy
      render json: { message: "Property has been deleted successfully!" }
    else
      render_error_messages(@property)
    end
  end

  def house_detail_options
    render json: House.detail_options
  end

  def condo_detail_options
    render json: Condo.detail_options
  end

  def property_filters
    @properties = @current_user.properties.where("type = ?", params[:property_type].titleize.gsub(" ", ""))
  end

  def recent_property
    @properties = @current_user.properties.where('created_at >= :five_days_ago', :five_days_ago => 5.days.ago)
    if @properties
      @properties
    else
      render json: { message: "Property not found" }, status: :unprocessable_entity
    end
  end

  def matching_property
    _weight_age = 0
    if @current_user.user_preference.present?
      @properties = UserPreferencesService.new.search_property(@current_user)
      if @properties.present?
        @properties&.sort_by{|e| e[:created_at]}
      else
        render json: { message: "Matching property not found" }, status: :unprocessable_entity
      end
    else
      render json: {}, status: :ok
    end
  end

  def matching_dream_address
    @properties = []
    @property_list = Property.where("address ILIKE (?)",@current_user.dream_addresses.pluck(:location))
    @property_list.each do |record|
      record.weight_age = _weight_age
      @properties << record
    end
    if  @properties.present?
      render json: { message:  @properties }, status: :ok
    else
      render json: @properties, status: :ok
    end
  end

  def user_detail
    @user = User.find_by(id: params[:user_id])
  end

  private

    def house_params
      params.require(:property).permit(
        :title, :price, :currency_type, :address, :unit, :property_tax, :tax_year, :property_description, :year_built, :appliances_and_other_items,
        :lot_frontage, :lot_frontage_unit, :lot_depth, :lot_depth_unit, :lot_size, :lot_size_unit, :is_lot_irregular, :lot_description,
        :house_type, :house_style, :bed_rooms, :bath_rooms, :total_number_of_rooms, :total_parking_spaces, :garage, :garage_spaces, :exterior, :driveway,
        :water, :sewer, :heat_source, :heat_type, :air_conditioner, :laundry, :fireplace, :central_vacuum, :basement, :pool, images: []
      )
    end

    def condo_params
      params.require(:property).permit(
        :title, :price, :currency_type, :address, :unit, :property_tax, :tax_year, :property_description, :year_built, :appliances_and_other_items,
        :locker, :condo_corporation_or_hqa, :condo_fees, :condo_type, :condo_style, :bed_rooms, :bath_rooms, :total_number_of_rooms,
        :total_parking_spaces, :garage_spaces, :exterior, :balcony, :exposure, :security, :pets_allowed, :included_utilities,
        :water, :sewer, :heat_source, :heat_type, :air_conditioner, :laundry, :fireplace, :central_vacuum, :basement, :pool, images: []
      )
    end

    def vacant_land_params
      params.require(:property).permit(
        :title, :price, :currency_type, :address, :unit, :property_tax, :tax_year, :property_description,
        :lot_frontage, :lot_frontage_unit, :lot_depth, :lot_depth_unit, :lot_size, :lot_size_unit,
        :is_lot_irregular, :lot_description, images: []
      )
    end

    def set_property
      @property = Property.find_by(id: params[:id])
      render json: { error: "Property with id: #{params[:id]} does not exist" }, status: 422 unless @property
    end

    def validate_property_type
      return if params[:property_type].in? ["house", "condo", "vacant_land"]
      render json: { error: "Property type should be one of the following: house, condo, vacant_land" }, status: 422
    end

    def set_property_params
      @property_params = send("#{params[:property_type]}_params").merge({property_type: params[:property_type]})
    end

    def check_number_of_images
      @image_arr = @property_params[:images].blank? ? [] : @property_params[:images]
      unless @image_arr.length <= 30
        render json: { message: "Images should not be more than 30" }, status: :unprocessable_entity
      end
    end

    def upload_image_to_cloudinary(image)
      begin
        require "down"
        tempfile = Down.download(image["uri"])
        @property.images.attach(io: File.open(image["uri"]), filename: image["name"], content_type: image["type"])
      rescue => e
        render json: { error: e.message }, status: 404
      end
    end

    def calculate_weightage(_weight_age,matching_item,number)
      _weight_age = _weight_age + number if matching_item.present?
    end
end
