json.user do
  json.auth_token @token
  json.partial! 'registration', user: @current_user
end
