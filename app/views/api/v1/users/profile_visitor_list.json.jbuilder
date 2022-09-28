json.visitor @visitor do |visit|
	json.id visit.id
	json.visitor_id visit.visit_id
	json.visitor_viewed_time visit.created_at
	json.visitor_name visit.visitor.full_name
	json.visitor_email visit.visitor.email
	json.visitor_phone_number visit.visitor.phone_number
	json.description visit.visitor.description
	json.country_code visit.visitor.country_code
	json.country_name visit.visitor.country_code
	json.hourly_rate visit.visitor.currency_amount
	json.profile_type visit.visitor.profile_type
	json.address visit.visitor.address
	json.login_type visit.visitor.login_type
  json.profile_complete visit.visitor.profile_complete
	json.visitor_image visit.visitor.avatar.attached? ? rails_blob_url(visit.visitor.avatar) : ""
end