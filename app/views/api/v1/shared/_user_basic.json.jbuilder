json.extract! user,
  :id, :full_name, :email, :is_otp_verified, :is_confirmed, :phone_number, :country_code, :country_name,
  :licensed_realtor, :contacted_by_real_estate, :user_type, :profile_type, :description, :login_type,
  :profile_complete, :hourly_rate, :latitude, :longitude, :address

json.avatar user.avatar.attached? ? rails_blob_url(user.avatar) : ""
json.is_subscribed user.subscribed?
