class Api::V1::UserPreferencesController < Api::V1::ApiController
  def create_preference
    @preference = @current_user.build_user_preference(preference_params)
    if @preference.save
      @preference
    else
      render_error_messages(@preference)
    end
  end

  private

    def preference_params
      params.require(:preference).permit(:user_id, :property_type, :min_price, :max_price,
                                         :min_bedrooms, :max_bedrooms, :min_bathrooms, :max_bathrooms,
                                         :property_style, :min_lot_frontage, :min_lot_size,
                                         :max_lot_size, :min_living_space, :max_living_space, :parking_spot,
                                         :garbage_spot, :max_age, :balcony, :security, :laundry)
    end
end
