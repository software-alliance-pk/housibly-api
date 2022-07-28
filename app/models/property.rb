class Property < ApplicationRecord
  cattr_accessor :property_type
  has_many_attached :images
  # has_many :rooms, dependent: :destroy
  belongs_to :user
  validates :price, :lot_frontage_sq_meter, :lot_depth_sq_meter,:bath_rooms,
            :bed_rooms, :house_type, :house_style, :air_conditioner,
            :parking_spaces, :garage_spaces,  presence: true
end
