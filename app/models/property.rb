class Property < ApplicationRecord
  include PgSearch::Model

  before_save :add_the_lnt_and_lng_property
  before_save :convert_to_feet, unless: ->(property){property.property_type == "condo"}

  # reverse_geocoded_by :latitude, :longitude
  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  scope :price_matcher, ->(min_price,max_price){ where("price between (?) and (?)",min_price,max_price)}
  scope :bath_rooms_matcher, ->(min_bath_room,max_bath_room){ where("bath_rooms between (?) and (?)",min_bath_room,max_bath_room)}
  scope :bed_rooms_matcher, ->(min_bed_room,max_bed_room){ where("bed_rooms between (?) and (?)",min_bed_room,max_bed_room)}
  scope :property_type_matcher,-> (type){ where("type ilike (?)",type&.titleize)}
  # scope :property_parking_spot, -> (min_spot,max_spot){where("total_parking_spaces between (?) and (?)",min_spot,max_spot)}
  scope :property_balcony, -> (balcony){ where("balcony = (?)",balcony)}
  scope :property_laundry, -> (laundry){ where("laundry = (?)",laundry)}
  scope :property_garage, -> (garage){where("garage = (?)",garage)}
  scope :property_security, -> ( security){where("security = (?)",security)}
  # scope :property_min_lot_frontage, -> (min_lot_frontage){where("lot_frontage = (?)",min_lot_frontage)}
  # scope :property_min_lot_size, -> (min_lot_size,max_lot_size){where("lot_size = (?) or lot_size = (?)",min_lot_size,max_lot_size)}
  scope :property_total_number_of_rooms, -> (min_rooms,max_rooms){ where("total_number_of_rooms between (?) and (?)",min_rooms,max_rooms)}
  scope :property_style_matcher, -> (style){ where("condo_style = (?) or house_style = (?)",style,style)}
  scope :property_type_matcher_2, -> (type){ where("condo_type = (?) or house_type = (?)",type,type)}
  #scope :property_living_space, -> (min_living,max_living){where("living_space = (?) or living_space (?)",min_living.to_s,max_living.to_s)}
  scope :property_age, ->  (age){where("year_built between (?) and (?)",age,Date.today.strftime("%y").to_i)}

  scope :count_house, -> { where("type = (?)","House").count }
  scope :count_vacant_land, -> { where("type = (?)","VacantLand").count }
  scope :count_condo, -> { where("type = (?)","Condo").count }
  scope :house, -> { where("type = (?)","House") }
  scope :vacant_land, -> { where("type = (?)","VacantLand") }
  scope :condo, -> { where("type = (?)","Condo") }

  scope :not_from_user, -> (user_id){ where.not(user_id: user_id) }

  belongs_to :user
  has_many_attached :images
  has_many :property_bookmarks, dependent: :destroy
  has_many :user_notifications, dependent: :destroy
  has_many :rooms, dependent: :destroy
  accepts_nested_attributes_for :rooms, allow_destroy: true

  validates :price, :currency_type, presence: true
  validates :house_type, :house_style, presence: true, if: ->(property){property.property_type == "house"}
  validates :condo_type, :condo_style, presence: true, if: ->(property){property.property_type == "condo"}

  validates :lot_frontage_unit, :lot_depth_unit, :lot_size_unit, presence: true, unless: ->(property){property.property_type == "condo"}
  validates :bed_rooms, :bath_rooms, :air_conditioner, :garage_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}
  # validates :total_parking_spaces, presence: true, unless: ->(property){property.property_type == "vacant_land"}

  # validate :validate_room_levels, unless: ->(property){property.property_type == "vacant_land"}
  validate :validate_detail_options, unless: ->(property){property.property_type == "vacant_land"}
  validate :validate_measurement_units, unless: ->(property){property.property_type == "condo"}

  attr_writer :property_type

  # attribute reader
  def property_type
    type.underscore
  end

  # for conversion to/from feet
  CONVERSION_FACTORS = {
    meter: 0.3048, # 1 foot = 0.3048 meter
    square_meter: 0.09290304 # 1 square foot = 0.09290304 square meter
  }

  def lot_depth
    (self[:lot_depth].blank? || lot_depth_unit == 'feet') ? self[:lot_depth] : self[:lot_depth]*CONVERSION_FACTORS[:meter]
  end

  def lot_frontage
    (self[:lot_frontage].blank? || lot_frontage_unit == 'feet') ? self[:lot_frontage] : self[:lot_frontage]*CONVERSION_FACTORS[:meter]
  end

  def lot_size
    (self[:lot_size].blank? || lot_frontage_unit == 'feet') ? self[:lot_size] : self[:lot_size]*CONVERSION_FACTORS[:square_meter]
  end

  def bookmarked_by_user?(user_id)
    property_bookmarks.exists?(user_id: user_id)
  end

  def self.detail_options
    # will be moved to database after fields and format are finalized
    {
      house_type: {
        attached: 'Attached/Row/Townhouse',
        semi_detached: 'Semi-Detached',
        detached: 'Detached',
        mobile: 'Mobile/Trailer',
        duplex: 'Duplex (2 Units)',
        multiplex: 'Multiplex (4+ Units)',
        cottage: 'Cottage'
      },
      house_style: {
        one_storey: 'Bungalow (1 Storey)',
        one_half_storey: '1 1/2 Storey',
        two_storey: '2 Storey',
        two_half_storey: '2 1/2 Storey',
        three_storey: '3 Storey',
        backsplit: 'Backsplit',
        sidesplit: 'Sidesplit'
      },
      condo_type: {
        condo_apartment: 'Condo Apartment',
        condo_townhouse: 'Condo Townhouse',
        co_ownership: 'Co-Op/Co-Ownership',
        detached: 'Detached Condo',
        semi_detached: 'Semi-Detached Condo'
      },
      condo_style: {
        apartment: 'Apartment',
        townhouse: 'Townhouse',
        two_storey: '2 Storey',
        three_storey: '3 Storey',
        studio: 'Studio/Bachelor',
        loft: 'Loft',
        multi_level: 'Multi-level'
      },
      exterior: {
        brick: 'Brick',
        concrete: 'Concrete',
        glass: 'Glass',
        metal_siding: 'Metal Siding',
        stone: 'Stone',
        stucco: 'Stucco',
        vinyl: 'Vinyl',
        wood: 'Wood',
        other: 'Other'
      },
      balcony: {
        yes: 'Yes',
        no: 'No',
        terrace: 'Terrace'
      },
      exposure: {
        north: 'North',
        northeast: 'Northeast',
        northwest: 'Northwest',
        south: 'South',
        southeast: 'Southeast',
        southwest: 'Southwest',
        east: 'East',
        west: 'West'
      },
      security: {
        guard: 'Guard/Concierge',
        system: 'System',
        none: 'None'
      },
      pets_allowed: {
        yes: 'Yes',
        no: 'No',
        with_restrictions: 'Yes With Restrictions'
      },
      included_utilities: {
        electricity: 'Electricity',
        water: 'Water',
        gas: 'Gas',
        propane: 'Propane',
        cable_tv: 'Cable TV',
        internet: 'Internet',
        none: 'None'
      },
      water: {
        municipal: 'Municipal',
        well: 'Well',
        other: 'Other'
      },
      sewer: {
        municipal: 'Municipal',
        septic: 'Septic',
        other: 'Other'
      },
      heat_source: {
        electricity: 'Electricity',
        oil: 'Oil',
        gas: 'Gas',
        propane: 'Propane',
        solar: 'Solar',
        other: 'Other'
      },
      heat_type: {
        forced_air: 'Forced Air',
        baseboard_heater: 'Baseboard Heater',
        radiant: 'Water/Radiant',
        other: 'Other'
      },
      air_conditioner: {
        central_air: 'Central Air',
        wall_unit: 'Wall Unit',
        window_unit: 'Window Unit',
        none: 'None',
        other: 'Other'
      },
      laundry: {
        ensuite: 'Ensuite',
        laundry_room: 'Laundry Room'
      },
      fireplace: {
        gas: 'Gas',
        wood: 'Wood',
        none: 'None'
      },
      basement: {
        apartment: 'Apartment',
        finished: 'Finished',
        separate_entrance: 'Separate Entrance',
        unfinished: 'Unfinished',
        walk_out: 'Walk-Out',
        none: 'None'
      },
      driveway: {
        private: 'Private',
        mutual: 'Mutual',
        lane_way: 'Lane-Way',
        front_yard: 'Front Yard',
        none: 'None',
        other: 'Other'
      },
      pool: {
        in_ground: 'In-Ground',
        above_ground: 'Above Ground',
        none: 'None'
      },
      room_levels: {
        basement: 'Basement',
        ground_floor: 'Ground Floor',
        first_floor: 'First Floor',
        second_floor: 'Second Floor',
        third_floor: 'Third Floor',
        fourth_floor: 'Fourth Floor'
      },
      length_units: {
        feet: 'feet',
        meter: 'meter'
      },
      area_units: {
        sqft: 'square feet',
        sqm: 'square meter'
      }
    }
  end

  private

    def convert_to_feet
      return if lot_depth_unit == 'feet' || (changed & ['lot_depth_unit', 'lot_depth', 'lot_frontage', 'lot_size']).blank?

      self[:lot_depth] /= CONVERSION_FACTORS[:meter] if self[:lot_depth].present?
      self[:lot_frontage] /= CONVERSION_FACTORS[:meter] if self[:lot_frontage].present?
      self[:lot_size] /= CONVERSION_FACTORS[:square_meter] if self[:lot_size].present?
    end

    def add_the_lnt_and_lng_property
      return unless address_changed?

      location = LocationFinderService.get_location_attributes(self.address)
      return unless location
      self.assign_attributes(longitude: location[:long], latitude: location[:lat], zip_code: location[:zip_code], country: location[:country], city: location[:city])
    end

    def validate_room_levels
      room_levels = Property.detail_options[:room_levels].keys
      rooms.each do |room|
        errors.add(:room_level, "has invalid value: #{room.level}") unless room.level.to_sym.in?(room_levels)
      end
    end

    def validate_measurement_units
      length_units = Property.detail_options[:length_units].keys
      errors.add(:lot_depth_unit, "has invalid value: #{lot_depth_unit}") unless lot_depth_unit&.to_sym.in?(length_units)
      errors.add(:lot_frontage_unit, "has invalid value: #{lot_frontage_unit}") unless lot_frontage_unit&.to_sym.in?(length_units)
      errors.add('lot depth unit and lot frontage unit', 'should be the same') unless lot_depth_unit == lot_frontage_unit

      area_units = Property.detail_options[:area_units].keys
      errors.add(:lot_size_unit, "has invalid value: #{lot_size_unit}") unless lot_size_unit&.to_sym.in?(area_units)
      unless (lot_size_unit&.to_sym == area_units[0] && lot_depth_unit&.to_sym == length_units[0]) ||
        (lot_size_unit&.to_sym == area_units[1] && lot_depth_unit&.to_sym == length_units[1])
        errors.add('lot depth unit and lot frontage unit and lot size unit', 'should have same base unit')
      end
    end

    def validate_detail_options
      self.attributes.each do |key, value|
        next unless value.present?

        allowed_values = Property.detail_options[key.to_sym]
        next unless allowed_values

        if value.is_a? Array
          value.each { |entry| errors.add(key, "has invalid value: #{entry}") unless allowed_values[entry.to_sym] }
        else
          errors.add(key, "has invalid value: #{value}") unless allowed_values[value.to_sym]
        end
      end
    end

end
