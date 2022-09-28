json.array! @school_pins do |school|
  json.id school.id
  json.name school.pin_name
  json.city school.city
  json.country school.country
  json.address school.address
  json.longtitude school.longtitude
  json.latitude school.latitude
  json.image school.image.attached? ? rails_blob_url(school.image) : ""

end
