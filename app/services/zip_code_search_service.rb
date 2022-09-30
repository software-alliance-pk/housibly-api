class ZipCodeSearchService
  def initialize
    @property = []
  end

  def search_property(zip_code)
    property = Property.where(zip_code: zip_code)
    if property.present?
      property.each do |record|
        record.weight_age = "100"
        @property << record
      end
    else
      @property = []
    end
    return @property
  end
end