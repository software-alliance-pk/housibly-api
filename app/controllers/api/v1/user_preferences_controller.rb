class Api::V1::UserPreferencesController < Api::V1::ApiController
  def create
    @preference = @current_user.build_user_preference(preference_params)
    if @preference.save
      @preference
    else
      render_error_messages(@preference)
    end
  end

  def index
    @preference = @current_user.user_preference
    if @preference
      @preference
    else
      render json: { message: "User has no preference" }
    end
  end

  private

    def preference_params
      params.require(:preference).permit(:user_id, :property_type, :min_price,
                                         :max_price, :min_bedrooms, :max_bedrooms,
                                         :min_bathrooms, :max_bathrooms, :max_age,
                                         :property_style, :min_lot_frontage, 
                                         :min_lot_size, :max_lot_size, :security,
                                         :min_living_space, :max_living_space,
                                         :parking_spot, :garbage_spot, :balcony,
                                         :laundry, :price_unit, :lot_size_unit,
                                         :living_space_unit, :property_types)
    end
end
