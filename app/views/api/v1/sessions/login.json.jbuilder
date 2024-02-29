json.user do
  json.auth_token @token
  json.mobile_device_token @mobile_device_token
  json.partial! 'api/v1/shared/user_basic', user: @user
  json.partial! 'api/v1/shared/user_setting', user_setting: @user.user_setting
end
