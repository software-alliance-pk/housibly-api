class Property < ApplicationRecord
  after_commit :add_the_lnt_and_lng_property, on: :create
  before_validation :create_balcony,:create_laundry,:create_security
  include PgSearch::Model

  scope :price_matcher, ->(min_price,max_price){ where("price between (?) and (?)",min_price,max_price)}
  scope :bath_rooms_matcher, ->(min_bath_room,max_bath_room){ where("bath_rooms between (?) and (?)",min_bath_room,max_bath_room)}
  scope :bed_rooms_matcher, ->(min_bed_room,max_bed_room){ where("bed_rooms between (?) and (?)",min_bed_room,max_bed_room)}
  scope :property_type_matcher,-> (type){ where("type ilike (?)",type&.titleize)}
  scope :property_parking_spot, -> (min_spot,max_spot){where("total_parking_spaces between (?) and (?)",min_spot,max_spot)}
  scope :property_balcony, -> (balcony){ where("balcony = (?)",balcony&.titleize)}
  scope :property_laundry, -> (laundry){ where("laundry = (?)",laundry&.titleize)}
  scope :property_garage, -> (garage){where("garage = (?)",garage&.titleize)}
  scope :property_security, -> ( security){where("security = (?)",security)}
  scope :property_min_lot_frontage, -> (min_lot_frontage){where("lot_frontage = (?)",min_lot_frontage)}
  scope :property_min_lot_size, -> (min_lot_size,max_lot_size){where("lot_size = (?) or lot_size = (?)",min_lot_size,max_lot_size)}
  scope :property_total_number_of_rooms, -> (min_rooms,max_rooms){ where("total_number_of_rooms between (?) and (?)",min_rooms,max_rooms)}
  scope :property_style_matcher, -> (style){ where("condo_style = (?) or house_style = (?)",style,style)}
  scope :property_type_matcher_2, -> (type){ where("condo_type = (?) or house_type = (?)",type,type)}
  #scope :property_living_space, -> (min_living,max_living){where("living_space = (?) or living_space (?)",min_living.to_s,max_living.to_s)}
  scope :property_age, ->  (age){where("year_built between (?) and (?)",age,Date.today.strftime("%y").to_i)}

  cattr_accessor :property_type
  cattr_accessor :bookmark_type
  has_many_attached :images
  has_many :bookmarks
  # has_many :rooms, dependent: :destroy
  belongs_to :user
  validates :price,presence: true
  validates :lot_frontage_unit, :currency_type, :lot_depth_unit, presence: true
  validates :bath_rooms, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :bed_rooms, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :house_type, presence: true, unless: ->(property){property.property_type == "vacant_land" || "condo"}
  validates :house_style, presence:  true, unless: ->(property){property.property_type == "vacant_land" || "condo"}
  validates :air_conditioner, presence:  true, unless: ->(property){property.property_type == "vacant_land"}
  # validates :total_parking_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :garage_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :condo_type, presence: true, unless: ->(property){property.property_type == "vacant_land" || "house"}
  validates :condo_style, presence: true, unless: ->(property){property.property_type == "vacant_land" || "house"}


  scope :count_house, -> { where("type = (?)","House").count }
  scope :count_vacant_land, -> { where("type = (?)","VacantLand").count }
  scope :count_condo, -> { where("type = (?)","Condo").count }
  scope :house, -> { where("type = (?)","House") }
  scope :vacant_land, -> { where("type = (?)","VacantLand") }
  scope :condo, -> { where("type = (?)","Condo") }



  def add_the_lnt_and_lng_property
    location  = LocationFinderService.get_location_attributes(self.address)
    self.update(longitude:location[:long],latitude: location[:lat],zip_code: location[:zip_code])
    # location[:country]
    # location[:city]
    # location[:district]
  end

  def create_balcony
    self.balcony = self.balcony&.titleize
  end

  def create_laundry
    self.laundry = self.laundry&.titleize
  end

  def create_security
    self.security = self.security&.titleize
  end

end
