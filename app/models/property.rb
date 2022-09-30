class Property < ApplicationRecord
  after_commit :add_the_lnt_and_lng_property, on: [:create,:update]
  include PgSearch::Model
  pg_search_scope :search_property_by_total_number_of_rooms,
                  against: :total_number_of_rooms,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_total_parking_spaces,
                  against: :total_parking_spaces,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_bed_rooms,
                  against: :bed_rooms,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_title,
                  against: :title,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_house_style,
                  against: :house_style,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_house_type,
                  against: :house_type,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }


  pg_search_scope :search_property_by_condo_type,
                  against: :condo_type,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_condo_style,
                  against: :condo_style,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_garage_spaces,
                  against: :garage_spaces,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }
  pg_search_scope :search_property_by_lot_depth_unit,
                  against: :lot_depth_unit,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }

  pg_search_scope :search_property_by_lot_frontage_unit,
                  against: :lot_frontage_unit,
                  using: {
                    tsearch: {any_word: true},
                    dmetaphone: {any_word: true, sort_only: true}
                  }
  
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


  def add_the_lnt_and_lng_property
    location  = LocationFinderService.get_location_attributes(self.address)
    self.update(longitude:location[:long],latitude: location[:lat],zip_code: location[:zip_code])
    # location[:country]
    # location[:city]
    # location[:district]
  end
end
