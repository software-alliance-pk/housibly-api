class Api::V1::PropertiesController < Api::V1::ApiController

  def create
    if params[:property][:property_type].in?(%w[house condo vacant_land])
      @property = params[:property][:property_type].capitalize.constantize.new(property_params)
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
      if @property.update(property_params)
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

  private

  def property_params
    params.require(:property).permit(:type, :title, :price, :year_built, :address, :unit, :lot_frontage,
                                     :lot_depth, :lot_size, :is_lot_irregular, :lot_description,
                                     :bath_room, :bed_room, :living_space, :parking_space, :garage_space,
                                     :garage, :parking_type, :parking_ownership, :condo_type, :condo_style,
                                     :driveway, :house_type, :house_style, :exterior, :water, :sewer,
                                     :heat_source, :heat_type, :air_conditioner, :laundry, :fire_place, :central_vacuum,
                                     :basement, :pool, :property_tax, :tax_year, :other_items, :locker,
                                     :condo_fees, :balcony, :exposure, :security, :pets_allowed, :included_utilities,
                                     :property_description, :is_property_sold, images: [])
  end
end
