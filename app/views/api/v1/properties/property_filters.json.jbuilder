json.array! @properties do |property|
  json.partial! 'property_details', property: property
  json.image property.images do |image|
    json.id image.id
    json.url rails_blob_url(image) rescue ""
  end
end
