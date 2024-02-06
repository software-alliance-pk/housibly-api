json.extract! user,
  :id, :full_name, :email, :is_otp_verified, :is_confirmed, :phone_number, :country_code, :country_name,
  :licensed_realtor, :contacted_by_real_estate, :user_type, :profile_type, :description, :login_type,
  :profile_complete, :hourly_rate, :latitude, :longitude, :address

json.avatar user.avatar.attached? ? rails_blob_url(user.avatar) : ""

json.average_rating user.support_closer_reviews.average(:rating)&.to_f || 0

json.has_subscription user.subscription.present? && user.subscription.status != 'canceled'

json.professions user.professions do |profession|
  json.extract! profession, :id, :title
end

json.schedule do
  json.extract! user.schedule, :id, :starting_time, :ending_time, :working_days
end if user.schedule

json.images user.images do |image|
  json.id image.signed_id
  json.url rails_blob_url(image) rescue ""
end

json.certificates user.certificates do |certificate|
  json.id certificate.signed_id
  json.url rails_blob_url(certificate) rescue ""
  json.size number_to_human_size(certificate.byte_size) rescue ""
end
