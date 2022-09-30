class UserCurrentLocationService
  def call(location)
    res = location
    puts res.data
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts " SIGN UP USER"
    puts res.data[:ip]
    puts res.data[:ip]
    puts res.data[:loc]
    puts res.data[:postal]
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    cordinates = res.data[:loc]&.split(",")
    puts LocationFinderService.get_location_attributes_by_reverse(cordinates)

  end
end