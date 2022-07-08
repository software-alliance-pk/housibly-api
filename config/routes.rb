Rails.application.routes.draw do
  get 'user_preferences/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/signup', to: 'registrations#create'
      post '/login_with_email', to: 'sessions#login_with_email'
      post '/login_with_phone', to: 'sessions#login_with_phone'
      post '/forgot_password/email', to: 'forgot_password#forgot_password_through_email'
      post '/forgot_password/phone', to: 'forgot_password#forgot_password_through_phone'
      post '/reset_password', to: 'forgot_password#reset_password'
      post '/social_login', to: 'social_logins#social_login'
      post '/preference', to: 'user_preferences#create_preference'
      post '/verify_otp', to: 'registrations#email_verify_otp?'
      get '/get_profile', to: 'users#get_profile'
      put '/register_user', to: 'registrations#update_personal_info'
      put '/update_profile', to: 'users#update_profile'
      get '/*a', to: 'application#not_found'
    end
  end
end
