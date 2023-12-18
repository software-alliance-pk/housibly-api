class UserPreference < ApplicationRecord
  belongs_to :user
  cattr_accessor :weight_age

  scope :price_matcher, ->(price){where("min_price >= ? OR max_price <= ?",price,price)}
  scope :bed_rooms_matcher, ->(bed_rooms){where("min_bedrooms >= ? OR max_bedrooms <= ?",bed_rooms,bed_rooms)}
  scope :bath_rooms_matcher, ->(bath_rooms){ where("min_bathrooms >= ? OR max_bathrooms <= ?",bath_rooms,bath_rooms)}
  scope :property_type_matcher,-> (type){ where("property_type ilike (?)",type&.titleize)}
  scope :property_parking_spot, -> (total_parking_spaces){where("parking_spot between (?) and (?)",total_parking_spaces,total_parking_spaces)}
  # scope :property_balcony, -> (balcony){ where("balcony = (?)",balcony&.titleize)}
  # scope :property_laundry, -> (laundry){ where("laundry = (?)",laundry.titleize)}
  scope :property_garage, -> (garage){where("garbage_spot = (?)",garage&.titleize)}
  scope :property_security, -> ( security){where("security = (?)",security)}
  scope :property_min_lot_frontage, -> (lot_frontage){where("min_lot_frontage = (?)",lot_frontage)}
  scope :property_min_lot_size, ->(lot_size){ where("min_lot_size >= ? OR max_lot_size <= ?",lot_size,lot_size)}

  # scope :property_min_lot_size, -> (min_lot_size,max_lot_size){where("lot_size = (?) or lot_size = (?)",min_lot_size,max_lot_size)}
  # scope :property_total_number_of_rooms, -> (min_rooms,max_rooms){ where("total_number_of_rooms between (?) and (?)",min_rooms,max_rooms)}
  # scope :property_style_matcher, -> (style){ where("condo_style = (?) or house_style = (?)",style,style)}
  # scope :property_type_matcher_2, -> (type){ where("condo_type = (?) or house_type = (?)",type,type)}
  # #scope :property_living_space, -> (min_living,max_living){where("living_space = (?) or living_space (?)",min_living.to_s,max_living.to_s)}
  # scope :property_age, ->  (age){where("year_built between (?) and (?)",age,Date.today.strftime("%y").to_i)}

end
