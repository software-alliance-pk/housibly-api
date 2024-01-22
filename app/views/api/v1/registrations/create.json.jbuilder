json.user do
  json.otp @user.reset_signup_token
  json.partial! 'registration', user: @user
end
