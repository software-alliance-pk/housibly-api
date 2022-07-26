Rails.application.routes.draw do
  get 'user_preferences/create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :properties, only: [:create, :get_all_cards, :update, :destroy]
      post '/signup', to: 'registrations#create'
      post '/login', to: 'sessions#login'
      post '/forgot_password/email', to: 'forgot_password#forgot_password_through_email'
      post '/forgot_password/phone', to: 'forgot_password#forgot_password_through_phone'
      post '/reset_password/email', to: 'forgot_password#reset_password_with_email'
      post '/reset_password/phone', to: 'forgot_password#reset_password_with_phone'
      post '/social_login', to: 'social_logins#social_login'
      post '/preference', to: 'user_preferences#create_preference'
      post '/verify_otp', to: 'registrations#verify_otp'
      post '/verify_otp/resend_otp', to: 'registrations#resend_otp'
      post '/tickets', to: 'supports#create_ticket'
      post '/tickets', to: 'supports#create_ticket'
      post '/card', to: 'payments#create'
      post '/apple_pay', to: 'payments#apple_pay'
      put '/register_user', to: 'registrations#update_personal_info'
      put '/update_profile', to: 'users#update_profile'
      put '/update_card', to: 'payments#update_card'
      put '/default_card', to: 'payments#set_default_card'
      get '/get_card', to: 'payments#get_card'
      get '/cards', to: 'payments#get_all_cards'
      get '/get_profile', to: 'users#get_profile'
      get '/get_default_card', to: 'payments#get_default_card'
      get '/property/filter', to: 'properties#property_filters'
      get '/tickets', to: 'supports#get_tickets'
      delete '/card', to: 'payments#destroy_card'
      delete '/card', to: 'payments#destroy_card'
      get '/static_page/:permalink', to: 'static_pages#static_page'
      get '/*a', to: 'api#not_found'
    end
  end
end
