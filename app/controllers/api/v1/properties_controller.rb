class Api::V1::PropertiesController < Api::V1::ApiController
  before_action :parse_parameters, only: [:create,:update]

  def create
    property_type = parse_parameters[:property_type]
    if property_type.in?(%w[house condo vacant_land])
      @property = property_type.titleize.gsub(" ", "").constantize.new(parse_parameters)
      @property.user = @current_user
      if @property.save
        @property
      else
        render_error_messages(@property)
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
    if property_params[:data]
      data = JSON.parse(property_params[:data])
      data.push("images" => property_params[:images])
      combine_parameters = data[0].merge(data[1])
      return combine_parameters.with_indifferent_access
    else
      render json: {error: "Parameters has some issue"}, status: 422
    end
  end

  def property_params
    params.require(:property).permit(:data,images: [])
  end
end
