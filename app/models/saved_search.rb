class SavedSearch < ApplicationRecord
  belongs_to :user

  validates_inclusion_of :search_type, in: ['circle', 'polygon', 'zip_code']
  validates_presence_of :title
  validates_presence_of :zip_code, if: -> { search_type == 'zip_code' }
  validates_presence_of :radius, if: -> { search_type == 'circle' }
  validate :validate_origin, if: -> { search_type == 'circle' }
  validate :validate_polygon, if: -> { search_type == 'polygon' }

  private

    def validate_origin
      errors.add(:origin, "has invalid value: #{origin}") unless valid_coordinates?(origin)
    end

    def validate_polygon
      unless polygon.is_a?(Array) && polygon.length >= 3 && polygon.none?{|point| !valid_coordinates?(point)}
        errors.add(:polygon, "has invalid value: #{polygon}")
      end
    end

    def valid_coordinates?(point)
      point.is_a?(Hash) && point['lat'].present? && point['lng'].present?
    end
end
