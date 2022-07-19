json.properties @properties do |property|
  hash = { property.type => property }
  json.merge! hash
  json.images property.images.attached? ? property.images.map { |image| rails_blob_url(image) } : ""
end
