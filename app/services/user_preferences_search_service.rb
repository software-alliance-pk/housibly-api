# frozen_string_literal: true

module UserPreferencesSearchService
  extend self

  def search_by_property(property_id, current_user_id, sort_criteria)
    property = Property.find_by_id(property_id)
    return nil unless property

    matches = []
    currency_conversion = CurrencyConversion.first

    UserPreference.not_of_user(current_user_id).where(property_type: property.property_type).order(updated_at: :desc).each do |preference|
      match_points = 0
      preference_data = {}

      preference.attributes.slice(*attribute_list[property.property_type]).each do |key, value|
        matched = false

        if key == 'max_age'
          matched = true if property.year_built.present? && property.year_built >= value.to_i.years.ago.year
        elsif value.is_a?(Hash) && property[key].present?
          if key == 'price' && preference.currency_type.present? && preference.currency_type != property.currency_type
            value['min'] = currency_conversion.convert(
              amount: value['min'].to_f,
              from: preference.currency_type,
              to: property.currency_type
            ) if value['min'].present?

            value['max'] = currency_conversion.convert(
              amount: value['max'].to_f,
              from: preference.currency_type,
              to: property.currency_type
            ) if value['max'].present?
          end

          if value['min'].present? && value['max'].present?
            matched = true if value['min'].to_f <= property[key] && value['max'].to_f >= property[key]
          elsif value['min'].present?
            matched = true if value['min'].to_f <= property[key]
          elsif value['max'].present?
            matched = true if value['max'].to_f >= property[key]
          end
        elsif value.is_a? Array
          matched = true if property[key].in? value
        end

        match_points += 1 if matched
        preference_data[key] = {'value' => value, 'matched' => matched}
      end

      match_percentage = (match_points/total_match_points[property.property_type])*100
      if match_percentage > 0
        preference_data.update({
          'match_percentage' => match_percentage,
          'updated_at' => preference.updated_at,
          'currency_type' => property.currency_type,
          'lot_size_unit' => property.lot_size_unit,
          'lot_frontage_unit' => property.lot_frontage_unit,
          'user' => {
            'id' => preference.user_id,
            'full_name' => preference.user.full_name,
            'avatar' => (preference.user.avatar.url rescue '')
          }
        })

        if property.lot_frontage_unit != 'feet'
          preference_data['lot_frontage']['value'] = UserPreference.get_metric_values(
            preference_data.dig('lot_frontage', 'value', 'min'),
            preference_data.dig('lot_frontage', 'value', 'max'),
            :meter
          )
          preference_data['lot_size']['value'] = UserPreference.get_metric_values(
            preference_data.dig('lot_size', 'value', 'min'),
            preference_data.dig('lot_size', 'value', 'max'),
            :square_meter
          )
        end

        matches << preference_data
      end
    end

    if sort_criteria == 'top_match'
      matches.sort_by {|match| -match['match_percentage']}
    else
      # already sorted by newest
      matches
    end
  end

  private

    def total_match_points
      {
        'house' => 11.0,
        'condo' => 13.0,
        'vacant_land' => 3.0
      }
    end

    def attribute_list
      {
        'house' => ['price', 'bed_rooms', 'bath_rooms', 'house_type', 'house_style', 'lot_frontage', 'lot_size',
                    'total_number_of_rooms', 'total_parking_spaces', 'garage_spaces', 'max_age'],
        'condo' => ['price', 'bed_rooms', 'bath_rooms', 'condo_type', 'condo_style', 'lot_frontage', 'lot_size',
                    'total_number_of_rooms', 'total_parking_spaces', 'balcony', 'security', 'laundry', 'max_age'],
        'vacant_land' => ['price', 'lot_frontage', 'lot_size']
      }
    end
end
