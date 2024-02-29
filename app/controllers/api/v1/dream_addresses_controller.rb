# frozen_string_literal: true

class Api::V1::DreamAddressesController < Api::V1::ApiController

  def index
    @dream_addresses = @current_user.dream_addresses
  end

  def create
    @address = @current_user.dream_addresses.build(dream_address_params)
    if @address.save
      if @current_user.user_setting.push_notification || @current_user.user_setting.inapp_notification
        UserPreferencesNotificationJob.perform_now(user_id: @current_user.id, preference_type: 'dream_address')
      end
    else
      render_error_messages(@address)
    end
  end

  def destroy
    dream_address = DreamAddress.find_by(id: params[:id])
    if dream_address.present?
      if dream_address.destroy
        render json: { message: 'Successfully deleted' }
      else
        render_error_messages(dream_address)
      end
    else
      render json: { message: "Dream address with id: #{params[:id]} not found" }, status: :not_found
    end
  end

  def fetch_property
    _weight_age = 0
    @property = []
    @property_list = ''
    if params[:using_polygon] == "true"
      if params[:polygon].present?
        @property = PolygonSearchService.new.search_property(params[:polygon])
        if @property.present?
          @property
        else
          render json: { message: "Any property does not match" }, status: :not_found
        end
      else
        render json: { message: "Please give suitable parameter" }, status: :unprocessable_entity
      end
    elsif params[:using_zip_code] == "true"
      if params[:using_zip_code].present?
        @property = ZipCodeSearchService.new.search_property(params[:zip_code])
        if @property.present?
          @property
        else
          render json: { message: "Any property does not match" }, status: :unprocessable_entity
        end
      else
        render json: { message: "Please give suitable parameter" }, status: :unprocessable_entity
      end
    elsif params[:user_preference] == "true"
      if @current_user.user_preference.present?

        # property_list_having_bed_rooms = (Property.ransack(min_bed_rooms_lteq_any: @current_user.user_preference.min_bedrooms).result || Property.ransack(max_bed_rooms_gteq_any: @current_user.user_preference.max_bathrooms).result)&.uniq
        # _value = calculate_weightage(_weight_age, property_list_having_bed_rooms, 14)
        # _weight_age = _value if _value.present?
        # property_list_having_style = Property.search_property_by_house_style(@current_user.user_preference.property_style) ||
        #   Property.search_property_by_condo_style(@current_user.user_preference.property_style)
        # _value = calculate_weightage(_weight_age, property_list_having_style, 14)
        # _weight_age = _value if _value.present?
        # property_list_having_type = Property.search_property_by_house_type(@current_user.user_preference.property_type) ||
        #   Property.search_property_by_condo_type(@current_user.user_preference.property_type)
        # _value = calculate_weightage(_weight_age, property_list_having_type, 14)
        # _weight_age = _value if _value.present?
        # _weight_age = _value if _value.present?
        # property_list_having_price = (Property.ransack(price_lteq_any: @current_user.user_preference.min_price).result || Property.ransack(price_gteq_any: @current_user.user_preference.max_price).result).uniq
        # _value = calculate_weightage(_weight_age, property_list_having_price, 14)
        # _weight_age = _value if _value.present?
        # property_list_having_frontage_unit = Property.search_property_by_lot_frontage_unit(@current_user.user_preference.min_lot_frontage)
        # _value = calculate_weightage(_weight_age, property_list_having_frontage_unit, 14)
        # _weight_age = _value if _value.present?
        # @property_list = (property_list_having_bed_rooms +
        #   property_list_having_style + property_list_having_price +
        #   property_list_having_frontage_unit +
        #   property_list_having_type)&.uniq
        # @property_list.each do |record|
        #   record.weight_age = _weight_age
        #   @property << record
        # end
        @property = UserPreferencesService.new.search_property(@current_user)
        if @property.present?
          @property
        else
          render json: { message: "Any property does not match" }, status: :unprocessable_entity
        end
      else
        render json: { message: "Please set your preference first" }, status: :unprocessable_entity
      end

    else
      render json: { message: "Please give user preference, zip code or polygon" }, status: :unprocessable_entity
    end
  end

  def fetch_user
    _weight_age = 0
    @user_prefernce = []
    @properties = []
    @user_prefernce_list = ''
    property = Property.find_by(id: params[:property_id])
    if property.present?
      if params[:user_preference] == "true"
        @user_prefernce = UserPreferencesService.new.search_user(property)

        # user_preference_list_having_bed_rooms = UserPreference.ransack(min_bed_rooms_lteq_any: property.bed_rooms).result
        # user_preference_list_having_bed_rooms = UserPreference.ransack(max_bed_rooms_gteq_any: property.bed_rooms).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_bed_rooms, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_style = UserPreference.ransack(property_style_matches: "%#{property.house_style}").result ||
        #   UserPreference.ransack(property_style_matches: "%#{property.condo_style}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_style, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_type = UserPreference.ransack(property_type_matches: "%#{property.house_type}").result ||
        #   UserPreference.ransack(property_style_matches: "%#{property.condo_type}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_type, 14)
        # _weight_age = _value if _value.present?
        # # _weight_age = _value if _value.present?
        # user_preference_list_having_price = UserPreference.ransack(min_price_lteq_any: property.price).result
        # user_preference_list_having_price = UserPreference.ransack(max_price_gteq_any: property.price).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_price, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_frontage_unit = UserPreference.ransack(min_lot_frontage_match: property.lot_frontage).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_frontage_unit, 14)
        # _weight_age = _value if _value.present?
        # @user_prefernce_list = (user_preference_list_having_bed_rooms +
        #   user_preference_list_having_style + user_preference_list_having_price +
        #   user_preference_list_having_frontage_unit +
        #   user_preference_list_having_type)&.uniq
        # @user_prefernce_list.each do |record|
        #   record.weight_age = _weight_age
        #   @user_prefernce << record
        # end
        if @user_prefernce.present?
          @user_prefernce
        else
          render json: { message: "No user available against user preference" }, status: :unprocessable_entity
        end
      elsif params[:newest_first] == "true"
        @user_prefernce = UserPreferencesService.new.newest_search_user(property)
        # user_preference = UserPreference.joins(:user).where("users.created_at >= ?", 1.week.ago)
        # user_preference_list_having_bed_rooms = user_preference.ransack(min_bed_rooms_lteq_any: property.bed_rooms).result ||
        #   user_preference.ransack(max_bed_rooms_gteq_any: property.bed_rooms).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_bed_rooms, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_style = user_preference.ransack(property_style_matches: "%#{property.house_style}").result ||
        #   user_preference.ransack(property_style_matches: "%#{property.condo_style}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_style, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_type = user_preference.ransack(property_type_matches: "%#{property.house_type}").result ||
        #   user_preference.ransack(property_style_matches: "%#{property.condo_type}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_type, 14)
        # _weight_age = _value if _value.present?
        # # _weight_age = _value if _value.present?
        # user_preference_list_having_price = user_preference.ransack(min_price_lteq_any: property.price).result ||
        #   user_preference.ransack(max_price_gteq_any: property.price).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_price, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_frontage_unit = user_preference.ransack(min_lot_frontage_match: property.lot_frontage).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_frontage_unit, 14)
        # _weight_age = _value if _value.present?
        # @user_prefernce_list = ((user_preference_list_having_bed_rooms +
        #   user_preference_list_having_style + user_preference_list_having_price +
        #   user_preference_list_having_frontage_unit +
        #   user_preference_list_having_type)&.uniq).compact
        # @user_prefernce_list.each do |record|
        #   record.weight_age = _weight_age
        #   @user_prefernce << record
        # end
        if @user_prefernce.present?
          @user_prefernce
        else
          render json: { message: "No user available against user preference" }, status: :unprocessable_entity
        end
      elsif params[:draw_map] == "true"
        if params[:polygon].present?
          @user_prefernce = PolygonSearchService.new.search_user(params[:polygon])
          if @user_prefernce.present?
            @user_prefernce
          else
            render json: { message: "No user available against user preference" }, status: :unprocessable_entity
          end
        else
          render json: { message: "Please give suitable parameter" }, status: :unprocessable_entity
        end
      elsif params[:dream_address] == "true"
        @user_prefernce = PolygonSearchService.new.dream_address_user
        if @user_prefernce.present?
          @user_prefernce
        else
          render json: { message: "No user available against user preference" }, status: :unprocessable_entity
        end
      elsif params[:top_match] == "true"
        @user_prefernce = UserPreferencesService.new.top_search_user(property)
        # user_preference_list_having_bed_rooms = UserPreference.ransack(min_bed_rooms_lteq_any: property.bed_rooms).result
        # user_preference_list_having_bed_rooms = UserPreference.ransack(max_bed_rooms_gteq_any: property.bed_rooms).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_bed_rooms, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_style = UserPreference.ransack(property_style_matches: "%#{property.house_style}").result ||
        #   UserPreference.ransack(property_style_matches: "%#{property.condo_style}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_style, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_type = UserPreference.ransack(property_type_matches: "%#{property.house_type}").result ||
        #   UserPreference.ransack(property_style_matches: "%#{property.condo_type}").result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_type, 14)
        # _weight_age = _value if _value.present?
        # # _weight_age = _value if _value.present?
        # user_preference_list_having_price = UserPreference.ransack(min_price_lteq_any: property.price).result
        # user_preference_list_having_price = UserPreference.ransack(max_price_gteq_any: property.price).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_price, 14)
        # _weight_age = _value if _value.present?
        # user_preference_list_having_frontage_unit = UserPreference.ransack(min_lot_frontage_match: property.lot_frontage).result
        # _value = calculate_weightage(_weight_age, user_preference_list_having_frontage_unit, 14)
        # _weight_age = _value if _value.present?
        # @user_prefernce_list = (user_preference_list_having_bed_rooms +
        #   user_preference_list_having_style + user_preference_list_having_price +
        #   user_preference_list_having_frontage_unit +
        #   user_preference_list_having_type)&.uniq
        # @user_prefernce_list.each do |record|
        #   record.weight_age = _weight_age
        #   if record.weight_age == "100"
        #     @user_prefernce << record
        #   end
        # end
        if @user_prefernce.present?
          @user_prefernce
        else
          render json: { message: "No user available against user preference" }, status: :unprocessable_entity
        end
      end
    else
      render json: { message: [] }
    end
  end

  def calculate_weightage(_weight_age, matching_item, number)
    _weight_age = _weight_age + number if matching_item.present?
  end

  private

    def dream_address_params
      params.require(:dream_address).permit(:address, :latitude, :longitude)
    end

end
