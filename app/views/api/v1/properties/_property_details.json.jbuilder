json.id property.id
json.property_type property.type
json.title property.title
json.price property.price
json.currency_type property.currency_type
json.address property.address
json.unit property.unit
json.year_built property.year_built
json.lot_frontage property.lot_frontage
json.lot_depth property.lot_depth
json.lot_size property.lot_size
json.lot_frontage_unit property.lot_frontage_unit
json.lot_depth_unit property.lot_depth_unit
json.lot_size_unit property.lot_size_unit
json.is_lot_irregular property.is_lot_irregular
json.lot_description property.lot_description
json.bath_rooms property.bath_rooms
json.bed_rooms property.bed_rooms
json.living_space property.living_space
json.garage_spaces property.garage_spaces
json.garage property.garage
json.parking_type property.parking_type
json.parking_ownership property.parking_ownership
json.condo_type property.condo_type
json.condo_style property.condo_style
json.driveway property.driveway
json.house_type property.house_type
json.house_style property.house_style
json.exterior property.exterior
json.water property.water
json.sewer property.sewer
json.heat_source property.heat_source
json.air_conditioner property.air_conditioner
json.laundry property.laundry
json.fireplace property.fireplace
json.central_vacuum property.central_vacuum
json.basement property.basement
json.pool property.pool
json.property_tax property.property_tax
json.tax_year property.tax_year
json.condo_corporation_or_hqa property.condo_corporation_or_hqa
json.appliances_and_other_items property.appliances_and_other_items
json.locker property.locker
json.condo_fees property.condo_fees
json.balcony property.balcony
json.exposure property.exposure
json.security property.security
json.pets_allowed property.pets_allowed
json.included_utilities property.included_utilities
json.property_description property.property_description
json.heat_type property.heat_type
json.user_id property.user_id
json.is_property_sold property.is_property_sold
json.total_number_of_rooms property.total_number_of_rooms
json.total_parking_spaces property.total_parking_spaces
json.is_bookmark property.is_bookmark
json.zip_code property.zip_code
json.longitude property.longitude
json.latitude property.latitude
json.weight_age property.weight_age
json.last_seen property&.user&.last_seen.present? ? "#{time_ago_in_words(property&.user&.last_seen)} ago" : ""
json.is_new property.created_at > 6.weeks.ago
json.rooms property.rooms do |room|
  json.partial! 'room', room: room
end
json.images property.images do |image|
  json.id image.signed_id
  json.url image.url rescue "" # use for direct link, see https://api.rubyonrails.org/classes/ActiveStorage/Blob.html#method-i-url
  # json.url rails_blob_url(image) rescue "" # use for redirect link, see https://guides.rubyonrails.org/active_storage_overview.html#redirect-mode
end
