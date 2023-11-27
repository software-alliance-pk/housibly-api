class Room < ApplicationRecord
  belongs_to :property
  validates_presence_of :name, :length_in_feet, :width_in_feet, :level
end
