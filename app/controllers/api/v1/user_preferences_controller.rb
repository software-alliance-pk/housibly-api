# frozen_string_literal: true

class Api::V1::UserPreferencesController < Api::V1::ApiController
  before_action :validate_property_type, only: [:create]
  before_action :sanitize_array_params, only: [:create]

  def index
    @preference = @current_user.user_preference
    unless @preference
      render json: { message: 'User has no preference' }
    end
  end

  def create
    @preference = @current_user.build_user_preference(preference_params)
    if @preference.save
      UserPreferencesNotificationJob.perform_now(user_id: @current_user.id)
    else
      render_error_messages(@preference)
    end
  end

  def get_potential_buyer_preferences
    return render json: {message: 'property_id parameter is missing'}, status: :unprocessable_entity unless params[:property_id]

    matches = UserPreferencesSearchService.search_by_property(params[:property_id], @current_user.id, params[:sort_criteria])
    if matches.nil?
      render json: {message: "No property with id: #{params[:property_id]} found"}, status: :unprocessable_entity
    else
      render json: matches
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
      return if preference_params[:property_type].in? ['house', 'condo', 'vacant_land']
      render json: { message: 'Property type should be one of the following: house, condo, vacant_land' }, status: 422
    end

    def sanitize_array_params
      # for removing blank values from arrays
      preference_params.each do |key, value|
        if value.is_a? Array
          params[:preference][key] = value.filter(&:present?)
        end
      end
    end
end
