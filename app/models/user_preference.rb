class UserPreference < ApplicationRecord
  belongs_to :user
  cattr_accessor :weight_age
  has_many :preference_properties, dependent: :destroy
  has_many :properties, through: :preference_properties, dependent: :destroy

  before_save :convert_to_feet, unless: ->(user_preference){user_preference.property_type == "condo"}

  validates_presence_of :property_type
  validate :validate_currency_type, if: -> { price.present? }
  validate :validate_measurement_units, unless: ->(user_preference){user_preference.property_type == "condo"}

  scope :not_of_user, -> (user_id){ where.not(user_id: user_id) }

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
    if self['lot_depth'].blank? || lot_depth_unit == 'feet'
      self['lot_depth']
    else
      UserPreference.get_metric_values(self['lot_depth']['min'], self['lot_depth']['max'], :meter)
    end
  end

  def lot_frontage
    if self['lot_frontage'].blank? || lot_frontage_unit == 'feet'
      self['lot_frontage']
    else
      UserPreference.get_metric_values(self['lot_frontage']['min'], self['lot_frontage']['max'], :meter)
    end
  end

  def lot_size
    if self['lot_size'].blank? || lot_frontage_unit == 'feet'
      self['lot_size']
    else
      UserPreference.get_metric_values(self['lot_size']['min'], self['lot_size']['max'], :square_meter)
    end
  end

  def self.get_metric_values(min, max, unit)
    lot_data = {}
    lot_data['min'] = min.to_f * Property::CONVERSION_FACTORS[unit] if min.present?
    lot_data['max'] = max.to_f * Property::CONVERSION_FACTORS[unit] if max.present?
    lot_data
  end

  private

    def convert_to_feet
      return if lot_frontage_unit == 'feet'

      self['lot_depth']['min'] = self['lot_depth']['min'].to_f / Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_depth', 'min')
      self['lot_depth']['max'] = self['lot_depth']['max'].to_f / Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_depth', 'max')

      self['lot_frontage']['min'] = self['lot_frontage']['min'].to_f / Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_frontage', 'min')
      self['lot_frontage']['max'] = self['lot_frontage']['max'].to_f / Property::CONVERSION_FACTORS[:meter] if attributes.dig('lot_frontage', 'max')

      self['lot_size']['min'] = self['lot_size']['min'].to_f / Property::CONVERSION_FACTORS[:square_meter] if attributes.dig('lot_size', 'min')
      self['lot_size']['max'] = self['lot_size']['max'].to_f / Property::CONVERSION_FACTORS[:square_meter] if attributes.dig('lot_size', 'max')
    end

    def validate_measurement_units
      length_units = Property.detail_options[:length_units].keys
      errors.add(:lot_depth_unit, "has invalid value: #{lot_depth_unit}") unless lot_depth.blank? || lot_depth_unit&.to_sym.in?(length_units)
      errors.add(:lot_frontage_unit, "has invalid value: #{lot_frontage_unit}") unless lot_frontage.blank? || lot_frontage_unit&.to_sym.in?(length_units)
      errors.add('lot depth unit and lot frontage unit', 'should be the same') unless lot_depth.blank? || lot_frontage.blank? || lot_depth_unit == lot_frontage_unit

      return if lot_size.blank?

      area_units = Property.detail_options[:area_units].keys
      errors.add(:lot_size_unit, "has invalid value: #{lot_size_unit}") unless lot_size_unit&.to_sym.in?(area_units)
      comparison_unit = lot_depth_unit.present? ? lot_depth_unit : lot_frontage_unit
      unless comparison_unit.blank? || (lot_size_unit&.to_sym == area_units[0] && comparison_unit&.to_sym == length_units[0]) ||
        (lot_size_unit&.to_sym == area_units[1] && comparison_unit&.to_sym == length_units[1])
        errors.add('lot depth unit and lot frontage unit and lot size unit', 'should have same base unit')
      end
    end

    def validate_currency_type
      currency_types = Property.detail_options[:currency_type].keys
      errors.add(:currency_type, "has invalid value: #{currency_type}") unless currency_type&.to_sym.in?(currency_types)
    end

end
