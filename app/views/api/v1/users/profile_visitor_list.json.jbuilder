json.array! @visits do |visit|
	json.id visit.visit_id
	json.full_name visit.visitor.full_name
	json.email visit.visitor.email
	json.description visit.visitor.description
	json.country_code visit.visitor.country_code
	json.phone_number visit.visitor.phone_number
	json.viewed_time visit.updated_at
	json.avatar visit.visitor.avatar.attached? ? rails_blob_url(visit.visitor.avatar) : ""
end
