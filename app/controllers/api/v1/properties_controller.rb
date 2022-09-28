class Api::V1::PropertiesController < Api::V1::ApiController
  require 'uri'
  before_action :parse_parameters, only: [:create, :update]
  before_action :set_property, only: [:update, :destroy]
  before_action :check_number_of_images, only: [:update, :create]
  before_action :validate_property_type_or_set_the_property_type, only: [:update, :create]

  def create
    @property = @property_types.titleize.gsub(" ", "").constantize.new(parse_parameters)
    @property.user = @current_user
    if @property.save
      @property
    else
      render_error_messages(@property)
    end
  end

  def index
    @properties = @current_user.properties.order("created_at desc")
  end
  def get_property
    if params[:property_id].present?
      @property = Property.find_by(id: params[:property_id])
      if @property.present?
        @property
      else
        render json: { message: "Property Does not present" }, status: 404
      end
    else
      render json: { message: "Property id parameter is missing" }, status: 404
    end
  end

  def user_detail
    @user = User.find_by(id: params[:user_id])
  end

  def update
    @property.type = @property_types.titleize.gsub(" ", "").constantize
    if @property.update(@image_arr.length > 0 ? parse_parameters : parse_parameters.except(:images))
      @property
    else
      render_error_messages(@property)
    end
  end

  def recent_property
    @properties = @current_user.properties.where('created_at >= :five_days_ago', :five_days_ago => 5.days.ago)
    if @properties
      @properties
    else
      render json: {
        message: "Property not found"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @property.destroy
      render json: { message: "Property has been deleted successfully!" }
    else
      render_error_messages(@property)
    end
  end

  def property_filters
    if params[:type].present?
      if params[:type].in?(%w[house condo vacant_land VacantLand Vacant Land vacant land])
        @properties = @current_user.properties.where("type = ?", params[:type].titleize.gsub(" ", ""))
      else
        render json: { message: "Property type not valid" }, status: 422
      end
    else
      render json: { message: "Type not present" }, status: 404
    end
  end


  def matching_property
    @properties = []
    _weight_age = 0
    if @current_user.user_preference.present?
      property_list_having_bed_rooms = (Property.ransack(min_bed_rooms_lteq_any: @current_user.user_preference.min_bedrooms).result || Property.ransack(max_bed_rooms_gteq_any: @current_user.user_preference.max_bathrooms).result)&.uniq
      _value = calculate_weightage(_weight_age,property_list_having_bed_rooms,14)
      _weight_age = _value if _value.present?
      property_list_having_style = Property.search_property_by_house_style(@current_user.user_preference.property_style) ||
        Property.search_property_by_condo_style(@current_user.user_preference.property_style)
      _value = calculate_weightage(_weight_age,property_list_having_style,14)
      _weight_age = _value if _value.present?
      property_list_having_type = Property.search_property_by_house_type(@current_user.user_preference.property_type) ||
        Property.search_property_by_condo_type(@current_user.user_preference.property_type)
      _value = calculate_weightage(_weight_age,property_list_having_type,14)
      _weight_age = _value if _value.present?
      _weight_age = _value if _value.present?
      property_list_having_price = (Property.ransack(price_lteq_any: @current_user.user_preference.min_price).result  || Property.ransack(price_gteq_any: @current_user.user_preference.max_price).result).uniq
      _value = calculate_weightage(_weight_age,property_list_having_price,14)
      _weight_age = _value if _value.present?
      property_list_having_frontage_unit = Property.search_property_by_lot_frontage_unit(@current_user.user_preference.min_lot_frontage)
      _value = calculate_weightage(_weight_age,property_list_having_frontage_unit,14)
      _weight_age = _value if _value.present?
      @property_list = (property_list_having_bed_rooms+
        property_list_having_style+ property_list_having_price+
        property_list_having_frontage_unit+
        property_list_having_type)&.uniq
      @property_list.each do |record|
        record.weight_age = _weight_age
        @properties << record
      end
      @properties&.sort_by{|e| e[:created_at]}
    else
      @properties
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
      render json: {message:  @properties},status: :ok
    else
      render json:@properties ,status: :ok
    end
  end

  private
  def parse_parameters
    if property_params
      begin
        data = JSON.parse(property_params[:other_options])
        format_data = data&.map { |item| { item["title"].downcase.gsub(" ", "_") => item["value"] } }
        data = Hash[*format_data.map(&:to_a).flatten]
        data.store("price", property_params[:price])
        data.store("title", property_params[:title])
        data.store("year_built", property_params[:year_built])
        data.store("address", property_params[:address])
        data.store("lot_frontage", property_params[:lot_frontage])
        data.store("lot_frontage_unit", property_params[:lot_frontage_unit])
        data.store("lot_depth_unit", property_params[:lot_depth_unit])
        data.store("lot_depth", property_params[:lot_depth])
        data.store("lot_depth_unit", property_params[:lot_depth_unit])
        data.store("lot_size", property_params[:lot_size])
        data.store("lot_size_unit", property_params[:lot_size_unit])
        data.store("is_lot_irregular", property_params[:is_lot_irregular])
        data.store("lot_description", property_params[:lot_description])
        data.store("property_tax", property_params[:property_tax])
        data.store("tax_year", property_params[:tax_year])
        data.store("locker", property_params[:locker])
        data.store("property_type", property_params[:property_type])
        data.store("condo_corporation_or_hqa", property_params[:condo_corporation_or_hqa])
        data.store("currency_type", property_params[:currency_type])
        data.store("zip_code", property_params[:zip_code] )
        data.store("images", property_params[:images])
        return data.with_indifferent_access
      rescue => e
        render json: { error: e.message }, status: 422
      end
    else
      render json: { error: "Parameters has some issue" }, status: 422
    end
  end

  def property_params
    params.require(:property).permit(
      :zip_code,:property_type, :title, :price, :year_built, :address, :unit, :lot_frontage,
      :lot_frontage_unit, :lot_depth, :lot_depth_unit, :lot_size_unit, :is_lot_irregular,
      :lot_description, :property_tax, :tax_year, :locker, :condo_corporation_or_hqa,
      :lot_size, :currency_type, :other_options, images: []
    )
  end

  def set_property
    @property = Property.find_by(id: params[:id])
    render json: { error: "No Property find" }, status: 422 unless @property
  end

  def check_number_of_images
    @image_arr = property_params[:images].blank? ? [] : property_params[:images]
    unless @image_arr.length <= 30
      render json: { message: "Images should be less than 30" }, status: :unprocessable_entity
    end
  end

  def upload_image_to_cloundinary(image)
    begin
      require "down"
      tempfile = Down.download(image["uri"])
      @property.images.attach(io: File.open(image["uri"]), filename: image["name"], content_type: image["type"])
    rescue => e
      render json: { error: e.message }, status: 404
    end
  end

  def validate_property_type(property_types)
    property_types.in?(%w[house condo vacant_land House Condo Vacant Land vacant land Vacant_Land])
  end

  def validate_property_type_or_set_the_property_type
    @property_types = parse_parameters[:property_type]
    validate_property_type(@property_types) ? true : (render json: { error: "Property type should one of the following house, condo , vacant_land" }, status: 404)
  end

  def calculate_weightage(_weight_age,matching_item,number)
    _weight_age = _weight_age + number if matching_item.present?
  end
end
