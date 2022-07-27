class Api::V1::PropertiesController < Api::V1::ApiController
  require 'uri'
  before_action :parse_parameters, only: [:create,:update]

  def create
    property_types = parse_parameters[:property_type]
    if property_types.in?(%w[house condo vacant_land])
      image_arr = JSON.parse(parse_parameters["images"])
      if image_arr.length < 30
          @property = property_types.titleize.gsub(" ", "").constantize.new(parse_parameters.except(:images))
          @property.user = @current_user
          if @property.save
              image_arr.each do |image|
                @property.images.attach(io: File.open(image["uri"]), filename: image["name"], content_type: image["type"])
              end
            @property
          else
            render_error_messages(@property)
          end
          else
            render json: { message: "Number of images is greater than 30" }, status: 404
          end
    else
      render json: { message: "property_type does not exist" }, status: 404
    end
  end

  def index
    @properties = @current_user.properties.order("created_at desc")
  end

  def update
    @property = Property.find_by(id: params[:id])
    if @property
      if @property.update(parse_parameters)
        @property
      else
        render_error_messages(@property)
      end
    else
      render json: { message: "property not found" }, status: 404
    end
  end

  def destroy
    @property = Property.find_by(id: params[:id])
    if @property
      if @property.destroy
        render json: { message: "Property has been deleted successfully!" }
      else
        render_error_messages(@property)
      end
    else
      render json: { message: "property not found" }, status: 404
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
      data = JSON.parse(property_params[:other_options])
      format_data =  data&.map{ |item| {item["title"].downcase.sub(" ","_") => item["value"]} }
      data = Hash[*format_data.map(&:to_a).flatten]
      data.store("price",property_params[:price])
      data.store("year_built",property_params[:year_built])
      data.store("address", property_params[:address])
      data.store("lot_frontage_feet",property_params[:lot_frontage_feet])
      data.store("lot_frontage_sq_meter",property_params[:lot_frontage_sq_meter])
      data.store("lot_depth_sq_meter", property_params[:lot_depth_sq_meter])
      data.store("lot_depth_feet", property_params[:lot_depth_feet])
      data.store("lot_depth_sq_meter", property_params[:lot_depth_sq_meter])
      data.store("lot_size_feet",property_params[:lot_size_feet])
      data.store( "lot_size_sq_meter",property_params[:lot_size_sq_meter])
      data.store("is_lot_irregular",property_params[:is_lot_irregular])
      data.store("lot_description", property_params[:lot_description])
      data.store("property_tax",property_params[:property_tax])
      data.store("tax_year",property_params[:tax_year])
      data.store("locker", property_params[:locker])
      data.store("property_type", property_params[:property_type])
      data.store("condo_corporation_or_hqa", property_params[:condo_corporation_or_hqa])
      data.store("images",property_params[:images])
      #c data.push({"name"=> "images", "value" => property_params[:images]})
      return data.with_indifferent_access
    else
      render json: {error: "Parameters has some issue"}, status: 422
    end
  end

  def property_params
    params.require(:property).permit(:property_type,:title, :price,:year_built,:address,:unit,
                                     :lot_frontage_feet,:lot_frontage_sq_meter,:lot_depth_feet,
                                     :lot_depth_sq_meter,:lot_size_sq_meter,:is_lot_irregular,
                                     :lot_description,:property_tax,:tax_year,:locker,
                                     :condo_corporation_or_hqa,
                                     :other_options,:images)
  end
end
