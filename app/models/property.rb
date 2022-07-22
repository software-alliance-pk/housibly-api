class Property < ApplicationRecord
  cattr_accessor :property_type
  has_many_attached :images
  # has_many :rooms, dependent: :destroy
  belongs_to :user
end
