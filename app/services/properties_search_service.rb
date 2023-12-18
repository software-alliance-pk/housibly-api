class PropertiesSearchService

  def self.match(preference)
    where_args = ['']
    conjuction = ' AND '

    preference.each do |key, value|
      next if value.blank? || key.in?(['id', 'user_id', 'created_at', 'updated_at', 'property_type', 'currency_type', 'lot_size_unit'])

      if key == 'max_age'
        where_args[0] << conjuction if where_args[0].present?
        where_args[0] << 'year_built >= ?'
        where_args.push(value.to_i.years.ago.year)
        next
      end

      if value.is_a? Hash
        if value['min'] && value['max']
          where_args[0] << conjuction if where_args[0].present?
          where_args[0] << "#{key} BETWEEN ? AND ?"
          where_args.push(value['min'], value['max'])
        elsif value['min'] || value['max']
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
    Property.where(type: preference['property_type'].titleize.gsub(" ", "")).where(where_args).order(created_at: :desc)
  end

end
