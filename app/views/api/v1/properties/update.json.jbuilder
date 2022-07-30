json.partial! 'property_details', property: @property
json.image @property.images do |image|
  json.id image.id
  json.url image.url rescue ""
end
