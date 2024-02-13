json.user do
  json.otp @user.reset_signup_token
  json.mobile_device_token @user.mobile_device_token
  json.partial! 'api/v1/shared/user_basic', user: @user
end
