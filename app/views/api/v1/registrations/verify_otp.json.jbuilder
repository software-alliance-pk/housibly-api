json.user do
  json.auth_token @token
  json.partial! 'api/v1/shared/user_basic', user: @user
end
