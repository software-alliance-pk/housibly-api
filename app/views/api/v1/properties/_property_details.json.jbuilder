json.extract! property,
  :id, :property_type, :title, :price, :currency_type, :address, :unit, :year_built, :lot_frontage, :lot_depth, :lot_size,
  :lot_frontage_unit, :lot_depth_unit, :lot_size_unit, :is_lot_irregular, :lot_description, :bath_rooms, :bed_rooms, :living_space,
  :garage_spaces, :parking_type, :parking_ownership, :condo_type, :condo_style, :driveway, :house_type, :house_style, :exterior, :water,
  :sewer, :heat_source, :air_conditioner, :laundry, :fireplace, :central_vacuum, :basement, :pool, :property_tax, :tax_year,
  :condo_corporation_or_hqa, :appliances_and_other_items, :locker, :condo_fees, :balcony, :exposure, :security, :pets_allowed,
  :included_utilities, :property_description, :heat_type, :user_id, :is_property_sold, :total_number_of_rooms, :total_parking_spaces,
  :is_bookmark, :zip_code, :longitude, :latitude, :weight_age

json.last_seen property&.user&.last_seen.present? ? "#{time_ago_in_words(property&.user&.last_seen)} ago" : ""
json.is_new property.created_at > 6.weeks.ago
json.rooms property.rooms do |room|
  json.partial! 'room', room: room
end
json.images property.images do |image|
  json.id image.signed_id
  # json.url image.url rescue "" # use for direct link (not available for local), see https://api.rubyonrails.org/classes/ActiveStorage/Blob.html#method-i-url
  json.url rails_blob_url(image) rescue "" # use for redirect link, see https://guides.rubyonrails.org/active_storage_overview.html#redirect-mode
end
