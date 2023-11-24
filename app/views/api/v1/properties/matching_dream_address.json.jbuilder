json.array!  @properties do |property|
  json.partial! 'property_details', property: property
end
