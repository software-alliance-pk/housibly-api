json.user do
  json.name @user.full_name
  json.email_address @user.email
  json.auth_token @token
  json.login_type @user.login_type
  json.profile_complete @user.profile_complete
end