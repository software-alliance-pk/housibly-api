json.message "Property is bookmarked"
if @property.present?
  json.property @property
elsif @user.present?
  json.user @user
end
json.is_bookmark true
