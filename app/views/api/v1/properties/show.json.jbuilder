json.partial! 'property_details', property: @property
json.user_name @property.user.full_name
json.user_profile_type @property.user.profile_type
json.user_type @property.user.user_type
json.user_avatar @property.user.avatar.attached? ? rails_blob_url(@property.user.avatar) : ""
