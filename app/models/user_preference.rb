class UserPreference < ApplicationRecord
  belongs_to :user
  cattr_accessor :weight_age

  before_save :convert_to_feet, unless: ->(user_preference){user_preference.property_type == "condo"}

  validates_presence_of :property_type
  validate :validate_measurement_units, unless: ->(user_preference){user_preference.property_type == "condo"}

  scope :price_matcher, ->(price){where("min_price >= ? OR max_price <= ?",price,price)}
  scope :bed_rooms_matcher, ->(bed_rooms){where("min_bedrooms >= ? OR max_bedrooms <= ?",bed_rooms,bed_rooms)}
  scope :bath_rooms_matcher, ->(bath_rooms){ where("min_bathrooms >= ? OR max_bathrooms <= ?",bath_rooms,bath_rooms)}
  scope :property_type_matcher,-> (type){ where("property_type ilike (?)",type&.titleize)}
  scope :property_parking_spot, -> (total_parking_spaces){where("parking_spot between (?) and (?)",total_parking_spaces,total_parking_spaces)}
  # scope :property_balcony, -> (balcony){ where("balcony = (?)",balcony&.titleize)}
  # scope :property_laundry, -> (laundry){ where("laundry = (?)",laundry.titleize)}
  scope :property_garage, -> (garage){where("garbage_spot = (?)",garage&.titleize)}
  scope :property_security, -> ( security){where("security = (?)",security)}
  scope :property_min_lot_frontage, -> (lot_frontage){where("min_lot_frontage = (?)",lot_frontage)}
  scope :property_min_lot_size, ->(lot_size){ where("min_lot_size >= ? OR max_lot_size <= ?",lot_size,lot_size)}

  # scope :property_min_lot_size, -> (min_lot_size,max_lot_size){where("lot_size = (?) or lot_size = (?)",min_lot_size,max_lot_size)}
  # scope :property_total_number_of_rooms, -> (min_rooms,max_rooms){ where("total_number_of_rooms between (?) and (?)",min_rooms,max_rooms)}
  # scope :property_style_matcher, -> (style){ where("condo_style = (?) or house_style = (?)",style,style)}
  # scope :property_type_matcher_2, -> (type){ where("condo_type = (?) or house_type = (?)",type,type)}
  # #scope :property_living_space, -> (min_living,max_living){where("living_space = (?) or living_space (?)",min_living.to_s,max_living.to_s)}
  # scope :property_age, ->  (age){where("year_built between (?) and (?)",age,Date.today.strftime("%y").to_i)}

  def lot_depth
    if self[:lot_depth].blank? || lot_depth_unit == 'feet'
      self[:lot_depth]
    else
      ld = {}
      ld[:min] = self['lot_depth']['min']/Property::CONVERSION_FACTORS[:meter] if self['lot_depth']['min'].present?
      ld[:max] = self['lot_depth']['max']/Property::CONVERSION_FACTORS[:meter] if self['lot_depth']['max'].present?
      ld
    end
  end

  def lot_frontage
    if self[:lot_frontage].blank? || lot_frontage_unit == 'feet'
      self[:lot_frontage]
    else
      ld = {}
      ld[:min] = self['lot_frontage']['min']/Property::CONVERSION_FACTORS[:meter] if self['lot_frontage']['min'].present?
      ld[:max] = self['lot_frontage']['max']/Property::CONVERSION_FACTORS[:meter] if self['lot_frontage']['max'].present?
      ld
    end
  end

  def lot_size
    if self[:lot_size].blank? || lot_frontage_unit == 'feet'
      self[:lot_size]
    else
      ld = {}
      ld[:min] = self['lot_size']['min']/Property::CONVERSION_FACTORS[:square_meter] if self['lot_size']['min'].present?
      ld[:max] = self['lot_size']['max']/Property::CONVERSION_FACTORS[:square_meter] if self['lot_size']['max'].present?
      ld
    end
  end

  private

    def convert_to_feet
      return if lot_frontage_unit == 'feet'

      self['lot_depth']['min'] = self['lot_depth']['min'].to_f * Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_depth', 'min')
      self['lot_depth']['max'] = self['lot_depth']['max'].to_f * Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_depth', 'max')

      self['lot_frontage']['min'] = self['lot_frontage']['min'].to_f * Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_frontage', 'min')
      self['lot_frontage']['max'] = self['lot_frontage']['max'].to_f * Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_frontage', 'max')

      self['lot_size']['min'] = self['lot_size']['min'].to_f * Property::CONVERSION_FACTORS[:square_meter] if attributes.dig('lot_size', 'min')
      self['lot_size']['max'] = self['lot_size']['max'].to_f * Property::CONVERSION_FACTORS[:square_meter] if attributes.dig('lot_size', 'max')
    end

    def validate_measurement_units
      length_units = Property.detail_options[:length_units].keys
      errors.add(:lot_depth_unit, "has invalid value: #{lot_depth_unit}") unless lot_depth_unit.blank? || lot_depth_unit.to_sym.in?(length_units)
      errors.add(:lot_frontage_unit, "has invalid value: #{lot_frontage_unit}") unless lot_frontage_unit.blank? || lot_frontage_unit.to_sym.in?(length_units)
      errors.add('lot_depth_unit and lot_frontage_unit', 'should be the same') unless lot_depth_unit.blank? || lot_frontage_unit.blank? || lot_depth_unit == lot_frontage_unit

      # errors.add(:lot_size_unit, "has invalid value: #{lot_size_unit}") unless lot_size_unit.in?(Property.detail_options[:area_units].keys)
      # unless lot_depth_unit == lot_frontage_unit && lot_size_unit.include?(lot_depth_unit)
      #   errors.add('lot_depth_unit, lot_frontage_unit, lot_size_unit', 'should have same base unit')
      # end
    end

end
