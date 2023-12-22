class DreamAddress < ApplicationRecord
  include CsvCounter

  belongs_to :user
  after_commit :add_the_lnt_and_lng_property, on: :create

  def self.to_csv
    CsvCounter.update_csv_counter
    CSV.generate(headers: true) do |csv|
      csv << self.attribute_names
      all.each do |record|
        csv << record.attributes.values_at(*attribute_names)
      end
    end
  end

  private

    def add_the_lnt_and_lng_property
      location = LocationFinderService.get_location_attributes(self.location)
      return unless location
      self.update(longitude: location[:long], latitude: location[:lat])
    end
end
