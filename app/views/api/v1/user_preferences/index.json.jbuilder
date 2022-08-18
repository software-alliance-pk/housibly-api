json.preference do
  json.id @preference.id
  json.property_type @preference.property_type
  json.max_price @preference.max_price
  json.min_price @preference.min_price
  json.min_bedrooms @preference.min_bedrooms
  json.max_bedrooms @preference.max_bedrooms
  json.min_bathrooms @preference.min_bathrooms
  json.max_bathrooms @preference.max_bathrooms
  json.max_age @preference.max_age
  json.property_style @preference.property_style
  json.min_lot_frontage @preference.min_lot_frontage
  json.min_lot_size @preference.min_lot_size 
  json.max_lot_size @preference.max_lot_size
  json.security @preference.security
  json.min_living_space @preference.min_living_space
  json.max_living_space @preference.max_living_space
  json.parking_spot @preference.parking_spot
  json.garbage_spot @preference.garbage_spot
  json.balcony @preference.balcony
  json.laundry @preference.laundry
  json.price_unit @preference.price_unit
  json.lot_size_unit @preference.lot_size_unit
  json.living_space_unit @preference.living_space_unit

end