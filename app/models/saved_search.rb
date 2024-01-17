class SavedSearch < ApplicationRecord
  belongs_to :user

  validates_inclusion_of :search_type, in: ['circle', 'polygon', 'zip_code']
  validates_presence_of :title
  validates_presence_of :zip_code, if: -> { search_type == 'zip_code' }
  validate :validate_circle, if: -> { search_type == 'circle' }
  validate :validate_polygon, if: -> { search_type == 'polygon' }

  private

    def validate_circle
      # should be an array containing two coordinates, the origin point and a point on the circumference
      unless circle.is_a?(Array) && circle.length == 2 && circle.none?{|point| !valid_coordinates?(point)}
        errors.add(:circle, "has invalid value: #{circle}")
      end
    end

    def validate_polygon
      # should be an array containing at least three coordinates to create an enclosed space
      unless polygon.is_a?(Array) && polygon.length >= 3 && polygon.none?{|point| !valid_coordinates?(point)}
        errors.add(:polygon, "has invalid value: #{polygon}")
      end
    end

    def valid_coordinates?(point)
      point.is_a?(Hash) && point['lat'].present? && point['lng'].present?
    end
end
