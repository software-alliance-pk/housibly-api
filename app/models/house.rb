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

end
