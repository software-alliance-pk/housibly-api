module Api::V1::BookmarksHelper
	def  matching_preference_percentage(user,type,property)
		_weight_age = 0
		if type == "user_type"

		else
  			  _user_preference = user.user_preference
  			  if _user_preference.present?
  			  	   _weight_age = _weight_age + 30 if property.type == _user_preference.property_type
  			  	   _weight_age = _weight_age + 30 if property.price >= _user_preference&.min_price && property.price <= _user_preference&.max_price
  			  	   _weight_age = _weight_age + 20 if property.bath_rooms && _user_preference&.min_bathrooms <= _user_preference&.max_bathrooms
  			  	   _weight_age = _weight_age + 20 if property.bed_rooms && _user_preference&.min_bedrooms <= _user_preference&.max_bedrooms
  			  else
  			  	_weight_age
  			  end
		end
	end
end
