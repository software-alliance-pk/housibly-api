 json.partial! 'property_details', property: @property
  json.image @property&.images&.attached? ? @property&.images&.first.url : ""