json.array! @school_pins do |school|
  json.id school.id
  json.name school.pin_name
  json.longtitude school.longtitude
  json.latitude school.latitude
  json.address school.address
end
