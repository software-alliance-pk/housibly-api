puts @settings
json.id @settings&.id
json.push_notification @settings&.push_notification
json.inapp_notification @settings&.inapp_notification
json.email_notification @settings&.email_notification
json.user_id @settings&.user_id