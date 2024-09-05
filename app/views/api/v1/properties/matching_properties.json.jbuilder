json.array! @preference_properties do |prefernce_property|
  json.percentage prefernce_property.has_attribute?(:match_percentage) ? prefernce_property.match_percentage : 100 
  json.partial! 'property_details', property: prefernce_property.respond_to?("property") ? prefernce_property.property : prefernce_property
end