class Room < ApplicationRecord
  belongs_to :property
  validates_presence_of :name, :room_length, :room_width, :level
end
