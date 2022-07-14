json.user do
  json.name @user.full_name
  json.email_address @user.email
  json.auth_token @token
end