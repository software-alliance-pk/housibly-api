class DreamAddress < ApplicationRecord
  belongs_to :user
  geocoded_by :location
  after_validation :geocode, :if => :location_changed?
end
