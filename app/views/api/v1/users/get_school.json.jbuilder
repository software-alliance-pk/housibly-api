json.id @school_pin.id
json.name @school_pin.pin_name
json.address @school_pin.address
json.city @school_pin.city
json.country @school_pin.country
json.longtitude @school_pin.longtitude
json.latitude @school_pin.latitude
json.image @school_pin.image.attached? ? rails_blob_url(@school_pin.image) : ""