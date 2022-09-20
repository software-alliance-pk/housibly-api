module CsvCounter
  def self.update_csv_counter
    if csv_count = Setting.last.present?
      csv_count = Setting.last.csv_count
      Setting.update(csv_count:csv_count +1)
    else
      csv_count = Setting.create(csv_count: 1)
    end
  end

  def self.titlize_csv_headers(array)
    array.map { |item| item.titleize }
  end
end