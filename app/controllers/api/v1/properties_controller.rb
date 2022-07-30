class Api::V1::PropertiesController < Api::V1::ApiController
  require 'uri'
  before_action :parse_parameters, only: [:create,:update]
  before_action :set_property, only: [:update,:destroy]
  before_action :check_number_of_images, only: [:update,:create]
  before_action :validate_property_type_or_set_the_property_type, only: [:update,:create]

  def create
      @property = @property_types.titleize.gsub(" ", "").constantize.new(parse_parameters.except(:images))
      @property.user = @current_user
      if @property.save
        @image_arr.each do |image|
            upload_image_to_cloundinary(image)
          end
        @property
      else
        render_error_messages(@property)
      end
  end


  def index
    @properties = @current_user.properties.order("created_at desc")
  end

  def update
    @property.type = @property_types
    if @property.update(parse_parameters.except(:images))
       @property.images.purge
       @image_arr.each do |image|
         upload_image_to_cloundinary(image)
       end
       @property
    else
      render_error_messages(@property)
    end
  end
  def recent_property
    @properties = @current_user.properties.where('created_at >= :five_days_ago',:five_days_ago => 5.days.ago)
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
      if params[:type].in?(%w[house condo vacant_land])
        @properties = @current_user.properties.where("type = ?", params[:type].capitalize)
      else
        render json: { message: "Property type not valid" }, status: 422
      end
    else
      render json: { message: "Type not present" }, status: 404
    end
  end

  private

  def parse_parameters
    if property_params
      begin
      data = JSON.parse(property_params[:other_options])
      format_data =  data&.map{ |item| {item["title"].downcase.sub(" ","_") => item["value"]} }
      data = Hash[*format_data.map(&:to_a).flatten]
      data.store("price",property_params[:price])
      data.store("title",property_params[:title])
      data.store("year_built",property_params[:year_built])
      data.store("address", property_params[:address])
      data.store("lot_frontage",property_params[:lot_frontage])
      data.store("lot_frontage_unit",property_params[:lot_frontage_unit])
      data.store("lot_depth_unit", property_params[:lot_depth_unit])
      data.store("lot_depth", property_params[:lot_depth])
      data.store("lot_depth_unit", property_params[:lot_depth_unit])
      data.store("lot_size",property_params[:lot_size])
      data.store("lot_size_unit",property_params[:lot_size_unit])
      data.store("is_lot_irregular",property_params[:is_lot_irregular])
      data.store("lot_description", property_params[:lot_description])
      data.store("property_tax",property_params[:property_tax])
      data.store("tax_year",property_params[:tax_year])
      data.store("locker", property_params[:locker])
      data.store("property_type", property_params[:property_type])
      data.store("condo_corporation_or_hqa", property_params[:condo_corporation_or_hqa])
      data.store("currency_type", property_params[:currency_type])
      data.store("images",property_params[:images])
      return data.with_indifferent_access
      rescue => e
        render json: {error: e.message}, status: 422
      end
    else
      render json: {error: "Parameters has some issue"}, status: 422
    end
  end

  def property_params
    params.require(:property).permit(:property_type,:title, :price,:year_built,:address,:unit,
                                     :lot_frontage,:lot_frontage_unit,:lot_depth,
                                     :lot_depth_unit,:lot_size_unit,:is_lot_irregular,
                                     :lot_description,:property_tax,:tax_year,:locker,
                                     :condo_corporation_or_hqa,:lot_size,:currency_type,
                                     :other_options,:images)
  end

  def set_property
    @property = Property.find_by(id: params[:id])
    render json: {error: "No Property find"}, status: 422 unless  @property
  end

  def check_number_of_images
    @image_arr = JSON.parse(parse_parameters["images"]) unless parse_parameters["images"].blank?
    @image_arr = [] if @image_arr.blank?
    unless @image_arr.length <= 30
      render json: {message: "Images should be less than 30"}, status: :unprocessable_entity
    end
  end

  def upload_image_to_cloundinary(image)
    begin
      require "down"
      tempfile = Down.download(image["uri"])
      @property.images.attach(io: File.open(tempfile), filename: image["name"], content_type: image["type"])
    rescue => e
      render json: { error: e.message }, status: 404
    end
  end

  def validate_property_type(property_types)
    property_types.in?(%w[house condo vacant_land House Condo Vacant_Land])
  end

  def validate_property_type_or_set_the_property_type
    @property_types = parse_parameters[:property_type]
    validate_property_type(@property_types) ? true : (render json: { error: "Property type should one of the following house, condo , vacant_land" }, status: 404)
  end
end
