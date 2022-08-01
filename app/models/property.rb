class Property < ApplicationRecord
  cattr_accessor :property_type
  has_many_attached :images
  # has_many :rooms, dependent: :destroy
  belongs_to :user
  validates :price,presence: true
  validates :lot_frontage_unit, :currency_type, :lot_depth_unit, presence: true
  validates :bath_rooms, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :bed_rooms, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :house_type, presence: true, unless: ->(property){property.property_type == "vacant_land" || "condo"}
  validates :house_style, presence:  true, unless: ->(property){property.property_type == "vacant_land" || "condo"}
  validates :air_conditioner, presence:  true, unless: ->(property){property.property_type == "vacant_land"}
  validates :parking_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :garage_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  validates :condo_type, presence: true, unless: ->(property){property.property_type == "vacant_land" || "house"}
  validates :condo_style, presence: true, unless: ->(property){property.property_type == "vacant_land" || "house"}

end
