class Condo < Property
  include CsvCounter

  def self.to_csv
    CsvCounter.update_csv_counter
    CSV.generate(headers: true) do |csv|
      csv << CsvCounter.titlize_csv_headers(self.attribute_names)
      all.where(type: "Condo").each do |record|
        csv << record.attributes.values_at(*attribute_names)
      end
    end
  end

  def self.detail_options
    {
      condo_type: {
        condo_apartment: 'Condo Apartment',
        condo_townhouse: 'Condo Townhouse',
        co_ownership: 'Co-Op/Co-Ownership',
        detached: 'Detached Condo',
        semi_attached: 'Semi-Detached Condo'
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
      garage_spaces: {
        underground: 'Underground',
        surface: 'Surface',
        attached: 'Attached',
        detached: 'Detached'
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
        well: 'Well'
      },
      sewer: {
        municipal: 'Municipal',
        septic: 'Septic'
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
        board_heater: 'Baseboard Heater',
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
        finished: 'Finished',
        unfinished: 'Unfinished'
      }
    }
  end

end
