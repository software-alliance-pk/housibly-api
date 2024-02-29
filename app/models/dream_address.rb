class DreamAddress < ApplicationRecord
  include CsvCounter

  belongs_to :user

  validates_presence_of :address, :latitude, :longitude

  def self.to_csv
    CsvCounter.update_csv_counter
    CSV.generate(headers: true) do |csv|
      csv << self.attribute_names
      all.each do |record|
        csv << record.attributes.values_at(*attribute_names)
      end
    end
  end

end
