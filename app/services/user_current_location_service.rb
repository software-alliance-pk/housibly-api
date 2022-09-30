class UserCurrentLocationService
  def call(location)
    res = location
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    puts res
    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    res.address
  end
end