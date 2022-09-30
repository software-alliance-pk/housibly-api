class UserCurrentLocationService
  def call(location)
    res = location
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts " SIGN UP USER"
    puts res[:ip]
    puts res[:ip]
    puts res[:loc]
    puts res[:postal]
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    cordinates = res[:loc]&.split(",")
    puts LocationFinderService.get_location_attributes_by_reverse(cordinates)

  end
end