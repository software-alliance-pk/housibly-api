module PropertiesSearchService
  extend self

  def search_by_preference(preference, page_info, current_user_id)
    where_args = ['']
    conjuction = ' AND '

    preference.each do |key, value|
      next if value.blank? || key.in?(
        ['id', 'user_id', 'created_at', 'updated_at', 'property_type', 'currency_type', 'lot_size_unit', 'lot_depth_unit', 'lot_frontage_unit'])

      if key == 'max_age'
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << 'year_built >= ?'
        where_args.push(value.to_i.years.ago.year)
        next
      end

      if value.is_a? Hash
        if value['min'].present? && value['max'].present?
          where_args[0] << conjuction if where_args[0].present?
          where_args[0] << "#{key} BETWEEN ? AND ?"
          where_args.push(value['min'], value['max'])
        elsif value['min'].present? || value['max'].present?
          where_args[0] << conjuction if where_args[0].present?
          where_args[0] << "#{key} #{value['min'] ? '>=' : '<='} ?"
          where_args.push(value['min'] || value['max'])
        end
      elsif value.is_a? Array
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << "ARRAY[#{key}]::varchar[] && ARRAY[?]::varchar[]"
        where_args.push(value)
      else
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << "#{key} = ?"
        where_args.push(value)
      end
    end

    # pp where_args
    Property.not_from_user(current_user_id).where(type: preference['property_type'].titleize.gsub(" ", "")).where(where_args).order(created_at: :desc).paginate(page_info).to_a
  end

  def search_in_polygon(coordinates_array, page_info, current_user_id)
    # page = page_info[:page] || 1
    # end_index = page * page_info[:per_page]
    # prev_end_index = end_index - page_info[:per_page]

    properties = Property.not_from_user(current_user_id).where.not(latitude: nil).where.not(longitude: nil)

    # return [] if properties.count <= prev_end_index # return if no more pages

    polygon = Geokit::Polygon.new(coordinates_array.map{ |point| Geokit::LatLng.new(point['lat'], point['lng']) })
    properties_in_polygon = properties.filter do |property|
      begin
        polygon.contains?(Geokit::LatLng.new(property.latitude, property.longitude))
      rescue => e
        puts "Error in property coordinates. Property id: #{property.id}. Error message: #{e.message}"
      end
    end

    return properties_in_polygon

    # return [] if properties_in_polygon.count <= prev_end_index # return if no more pages

    # results = properties_in_polygon.first(end_index)
    # results.last(results.count - prev_end_index)
  end

  def search_in_circle(origin, radius, page_info, current_user_id)
    # p origin.values
    Property.not_from_user(current_user_id).within(radius, origin: origin.values)
  end

end
