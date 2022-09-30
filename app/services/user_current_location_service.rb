class UserCurrentLocationService
  def call(location)
    res = location
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts res
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    res.address
    puts res&.ip_address
    puts res&.city
    puts res&.country
    puts res&.full_address
    puts res&.district
  end
end