json.visitor @visitor do |visit|
	json.id visit.id
	json.visitor_id visit.visit_id
	json.visitor_name visit.visitor.full_name
	json.visitor_image visit.visitor.avatar.attached? ? rails_blob_url(visit.visitor.avatar) : ""
end