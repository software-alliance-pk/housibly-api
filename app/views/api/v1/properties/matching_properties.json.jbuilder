json.array! @preference_properties do |prefernce_property|
  json.percentage prefernce_property.match_percentage 
  json.partial! 'property_details', property: prefernce_property.property
end