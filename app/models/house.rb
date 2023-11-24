class House < Property
  include CsvCounter

  def self.to_csv
    CsvCounter.update_csv_counter
    CSV.generate(headers: true) do |csv|
      csv << CsvCounter.titlize_csv_headers(self.attribute_names)
      all.where(type: "House").each do |record|
        csv << record.attributes.values_at(*attribute_names)
      end
    end
  end

  def self.detail_options
    {
      house_type: {
        attached_row_th: 'Attached/Row/Townhouse',
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
      exterior: {
        brick: 'Brick',
        concrete: 'Concrete',
        metal_siding: 'Metal Siding',
        stone: 'Stone',
        stucco: 'Stucco',
        vinyl: 'Vinyl',
        wood: 'Wood',
        other: 'Other'
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
      fireplace: {
        gas: 'Gas',
        wood: 'Wood',
        none: 'None'
      },
      pool: {
        none: 'No',
        in_ground: 'In-Ground',
        above_ground: 'Above Ground'
      }
    }
  end

end
