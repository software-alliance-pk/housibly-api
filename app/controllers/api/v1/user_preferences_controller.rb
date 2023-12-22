class Api::V1::UserPreferencesController < Api::V1::ApiController
  before_action :validate_property_type, only: [:create]

  def index
    @preference = @current_user.user_preference
    unless @preference
      render json: { message: "User has no preference" }
    end
  end

  def create
    @preference = @current_user.build_user_preference(preference_params)
    unless @preference.save
      render_error_messages(@preference)
    end
  end

  private

    def preference_params
      params.require(:preference).permit(:property_type, :currency_type, :max_age, :is_lot_irregular, :lot_depth_unit,
        :lot_frontage_unit, :lot_size_unit, :central_vacuum, driveway: [], water: [], sewer: [], laundry: [], pool: [],
        balcony: [], exposure: [], security: [], pets_allowed: [], house_style: [], house_type: [], condo_style: [],
        condo_type: [], exterior: [], included_utilities: [], basement: [], heat_source: [], heat_type: [],
        air_conditioner: [], fireplace: [], price: [:min, :max], bed_rooms: [:min, :max], bath_rooms: [:min, :max],
        lot_size: [:min, :max], lot_depth: [:min, :max], lot_frontage: [:min, :max], total_number_of_rooms: [:min, :max],
        total_parking_spaces: [:min, :max], garage_spaces: [:min, :max]
      )
    end

    def validate_property_type
      return if preference_params[:property_type].in? ["house", "condo", "vacant_land"]
      render json: { message: "Property type should be one of the following: house, condo, vacant_land" }, status: 422
    end
end
