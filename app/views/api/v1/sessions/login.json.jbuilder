json.user do
  json.auth_token @token
  json.partial! 'api/v1/registrations/registration', user: @user
end
