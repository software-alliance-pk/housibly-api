json.user do
  json.otp @user.reset_signup_token
  json.partial! 'api/v1/shared/user_basic', user: @user
end
