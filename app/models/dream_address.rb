class DreamAddress < ApplicationRecord
  before_commit :add_the_lnt_and_lng_property
  include CsvCounter
  belongs_to :user
  def self.to_csv
    CsvCounter.update_csv_counter
    CSV.generate(headers: true) do |csv|
      csv << self.attribute_names
      all.each do |record|
        csv << record.attributes.values_at(*attribute_names)
      end
    end
  end

  def add_the_lnt_and_lng_property
    location  = LocationFinderService.get_location_attributes(self.address)
    self.longitude = location[:long]
    self.latitude = location[:lat]
    # location[:country]
    # location[:city]
    # location[:district]
  end
end
