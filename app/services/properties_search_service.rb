module PropertiesSearchService
  extend self

  def calculate_match_percentage(preference, page_info, current_user_id,property)
    matches = 0
    total_attributes = 0
    currency_conversion = CurrencyConversion.first
    where_args = ['']
    conjuction = ' OR '

    preference.each do |key, value|
      next if value.blank? || key.in?(
        ['id', 'user_id', 'created_at', 'updated_at', 'property_type', 'currency_type', 'lot_size_unit', 'lot_depth_unit', 'lot_frontage_unit'])
      if key == 'max_age'
        if property.year_built.present?
          total_attributes += 1
          matches += 1 if property.year_built >= value.to_i.years.ago.year
        end
      elsif value.is_a? Hash
        if key == 'price' && preference['currency_type'].present?
          # convert property prices to the same currency as the user preference for comparison
          if value['min'].present? && value['max'].present?
            total_attributes += 1
            where_args[0] = conjuction if where_args[0].present?
            where_args[0] = "price BETWEEN (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))
              AND (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))"
            where_args.push(value['min'], currency_conversion.rates[preference['currency_type']], value['max'], currency_conversion.rates[preference['currency_type']])
            min_price = where_args[1].to_f * where_args[2] / currency_conversion.rates[property.currency_type]
            max_price = where_args[3].to_f * where_args[4] / currency_conversion.rates[property.currency_type]
            if  property.price >= min_price.to_f &&  property.price <= max_price.to_f
              matches += 1
            end 
          elsif value['min'].present? || value['max'].present?
            total_attributes += 1
            if value['min'].present?
              if property[key].to_f >= (value['min'].to_f * currency_conversion.rates[preference['currency_type']] / currency_conversion.rates[property.currency_type])
                matches += 1
              end
            elsif value['max'].present?
             if property[key].to_f <= ( value['max'].to_f * currency_conversion.rates[preference['currency_type']] / currency_conversion.rates[property.currency_type])
              matches +=1
             end
            end
          end
        else
          if value['min'].present? && value['max'].present?
            total_attributes += 1
            matches += 1 if price[key] >= value['min'].to_f && price[key] <= value['max'].to_f
          elsif value['min'].present? || value['max'].present?
            total_attributes += 1
            if value["min"].present?
              matches += 1 if property[key].to_f >= value["min"].to_f
            elsif value["max"].present?
              matches += 1 if property[key].to_f <= value["max"].to_f
            end
          end
        end
      elsif value.is_a? Array
        total_attributes += 1
        if value.to_a.include? property[key] 
          matches += 1 
        end
      else
        total_attributes += 1
        matches += 1 if property[key] == value
      end
    end
    # Example calculation based on attributes (modify as per your actual attributes
    (matches.to_f / total_attributes * 100).round(2)
  end

  def get_percentage(where_args,current_user_id,preference)
    base_condition = Property.not_from_user(current_user_id)
                         .where(type: preference['property_type'].titleize.gsub(' ', ''))
    # Extract the main SQL condition
    sql_condition = where_args[0] # Remove newline characters and strip leading/trailing spaces
    count = 0
    conditions = where_args 
    param_index = 1 # Start from the second element since the first one is sql_condition
    result = []
    total_conditions = 0 

    sql_condition.split("OR").each do |query|
      total_conditions +=1 
      # Remove extra spaces
      query.strip!

      # Determine the number of placeholders in the query
      num_params = query.count("?")
      # Determine the arguments for the current query
      if num_params == 1
        result = base_condition.where(query, conditions[param_index])
        param_index += 1
      elsif num_params == 2
        result = base_condition.where(query, conditions[param_index], conditions[param_index + 1])
        param_index += 2
      elsif num_params == 4
        result = base_condition.where(query, conditions[param_index], conditions[param_index + 1], conditions[param_index + 2], conditions[param_index + 3])
        param_index += 4
      end
      if result.present?
        count += 1
      end
      result = nil
      # Check if the condition is met
    end
    percntage = (count.to_f / total_conditions.to_f) * 100
  end

  def buy_properties_listing(preference, page_info, current_user_id)
    currency_conversion = CurrencyConversion.first
    where_args = ['']
    conjuction = ' OR '

    preference.each do |key, value|
      next if value.blank? || key.in?(
        ['id', 'user_id', 'created_at', 'updated_at', 'property_type', 'currency_type', 'lot_size_unit', 'lot_depth_unit', 'lot_frontage_unit'])

      if key == 'max_age'
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << 'year_built >= ?'
        where_args.push(value.to_i.years.ago.year)
      elsif value.is_a? Hash
        if key == 'price' && preference['currency_type'].present?
          # convert property prices to the same currency as the user preference for comparison
          if value['min'].present? && value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "price BETWEEN (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))
              AND (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))"
            where_args.push(value['min'], currency_conversion.rates[preference['currency_type']], value['max'], currency_conversion.rates[preference['currency_type']])
          elsif value['min'].present? || value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "price #{value['min'] ? '>=' : '<='} (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))"
            where_args.push(value['min'] || value['max'], currency_conversion.rates[preference['currency_type']])
          end
        else
          if value['min'].present? && value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "#{key} BETWEEN ? AND ?"
            where_args.push(value['min'], value['max'])
          elsif value['min'].present? || value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "#{key} #{value['min'] ? '>=' : '<='} ?"
            where_args.push(value['min'] || value['max'])
          end
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
    
    percentage = get_percentage(where_args,current_user_id,preference)
    if percentage.to_i <= 70 &&  percentage.to_i >= 50
      # pp where_args
      Property.not_from_user(current_user_id)
        .where(type: preference['property_type'].titleize.gsub(' ', ''))
        .where(where_args)
        .order(created_at: :desc)
        .paginate(page_info).to_a
    end
  end
  
  def search_by_preference(preference, page_info, current_user_id)
    currency_conversion = CurrencyConversion.first
    where_args = ['']
    conjuction = ' OR '

    preference.each do |key, value|
      next if value.blank? || key.in?(
        ['id', 'user_id', 'created_at', 'updated_at', 'property_type', 'currency_type', 'lot_size_unit', 'lot_depth_unit', 'lot_frontage_unit'])

      if key == 'max_age'
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << 'year_built >= ?'
        where_args.push(value.to_i.years.ago.year)
      elsif value.is_a? Hash
        if key == 'price' && preference['currency_type'].present?
          # convert property prices to the same currency as the user preference for comparison
          if value['min'].present? && value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "price BETWEEN (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))
              AND (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))"
            where_args.push(value['min'], currency_conversion.rates[preference['currency_type']], value['max'], currency_conversion.rates[preference['currency_type']])
          elsif value['min'].present? || value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "price #{value['min'] ? '>=' : '<='} (? * ? / (SELECT (rates->>currency_type)::numeric FROM (SELECT * FROM currency_conversions FETCH FIRST 1 ROW ONLY) as first_row))"
            where_args.push(value['min'] || value['max'], currency_conversion.rates[preference['currency_type']])
          end
        else
          if value['min'].present? && value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "#{key} BETWEEN ? AND ?"
            where_args.push(value['min'], value['max'])
          elsif value['min'].present? || value['max'].present?
            where_args[0] << conjuction if where_args[0].present?
            where_args[0] << "#{key} #{value['min'] ? '>=' : '<='} ?"
            where_args.push(value['min'] || value['max'])
          end
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
    
    percentage = get_percentage(where_args,current_user_id,preference)
    if percentage.to_i > 70
      # pp where_args
      Property.not_from_user(current_user_id)
        .where(type: preference['property_type'].titleize.gsub(' ', ''))
        .where(where_args)
        .order(created_at: :desc)
        .paginate(page_info).to_a
    end
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
