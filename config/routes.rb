Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root "dashboards#index"
  resources :supports do
    member do
      get :get_specific_chat
      get :ticket_in_progress
      get :ticket_closed
      get :ticket_pending
    end
  end
  resources :sub_admins do
    member do
      get :deactive_admin
      get :active_admin
    end
  end
  resources :school_pins
  resources :dashboards do
    post :index
  end
  resources :support_closers do
    member do
      get :active_account
      get :deactive_account
    end
  end
  resources :guidelines do
    collection do
      post :job_list
      get :job_lists
      delete :job_list
    end
  end
  get '/delete_job_list/:id', to: 'guidelines#delete_job_list', as: :delete_job_list
  post "privacy_policy/:permalink", to: "guidelines#create"
   resources :users_data do
    collection do
      get :buy_vacant_land
      post :buy_vacant_land
      get :buy_house
      post :buy_house
      get :buy_condo
      post :buy_condo
      get :sell_vacant_land
      post :sell_vacant_land
      get :sell_house
      post :sell_house
      get :sell_condo
      post :sell_condo
      get :user_info
      get :dream_address
    end
  end
  resources :users_lists do
    member do
      get :active_account
      get :deactive_account
      get :user_profile
    end
  end
  devise_for :admins
  get "/sp_active_account/:id", to: 'support_closers#active_user', as: 'sp_active_account'
  get "/sp_deactive_account/:id", to: 'support_closers#deactive_user',as: 'sp_deactive_account'
  get "/privacy_policy/:permalink", to: 'guidelines#guidelines', as: 'privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :properties, only: [:create, :get_all_cards, :update, :destroy, :index, :recent_property] do
        collection do
          get 'matching_property'
          get 'matching_dream_address'
        end
      end
      post '/signup', to: 'registrations#create'
      post '/login', to: 'sessions#login'
      post '/forgot_password/email', to: 'forgot_password#forgot_password_through_email'
      post '/forgot_password/phone', to: 'forgot_password#forgot_password_through_phone'
      post '/reset_password/email', to: 'forgot_password#reset_password_with_email'
      post '/reset_password/phone', to: 'forgot_password#reset_password_with_phone'
      post '/social_login', to: 'social_logins#social_login'
      post '/verify_otp', to: 'registrations#verify_otp'
      post '/verify_otp/resend_otp', to: 'registrations#resend_otp'
      post '/tickets', to: 'supports#create_ticket'
      post '/tickets', to: 'supports#create_ticket'
      post '/card', to: 'payments#create'
      post '/apple_pay', to: 'payments#apple_pay'
      post '/create_product', to: 'payments#create_product'
      get '/get_pakeges', to: 'payments#get_pakeges'
      post '/create_subscription', to: 'payments#create_subscription'
      post '/cancel_subscription', to: 'payments#cancel_subscription'
      post '/delete_card', to: 'payments#destroy_card'
      post '/register_user', to: 'registrations#update_personal_info'
      put '/update_profile', to: 'users#update_profile'
      get '/search_support_closer', to: 'users#search_support_closer'
      get 'get_support_closers', to: 'users#get_support_closers'
      post 'support_closer_profile', to: 'users#support_closer_profile'
      put 'update_support_closer_profile', to: 'users#update_support_closer_profile'
      get 'blocked_users', to: 'users#blocked_users'
      get 'unblocked_users', to: 'users#unblocked_users'
      post 'block_unblock_user', to: 'users#block_unblock_user'
      get 'reported_users', to: 'users#reported_users'
      get 'profile_visitor_list', to: 'users#profile_visitor_list'
      post 'view_user_profile', to: 'users#view_user_profile'
      post '/update_notification', to: 'users#update_notification'
      put '/update_card', to: 'payments#update_card'
      put '/default_card', to: 'payments#set_default_card'
      get '/get_card', to: 'payments#get_card'
      get '/cards', to: 'payments#get_all_cards'
      get '/get_profile', to: 'users#get_profile'
      get '/get_default_card', to: 'payments#get_default_card'
      post '/property/filter', to: 'properties#property_filters'
      get '/tickets', to: 'supports#get_tickets'
      get '/static_page/:permalink', to: 'static_pages#static_page'
      get '/recent_property', to: 'properties#recent_property'
      resources :bookmarks, only:  [:create, :destroy] do
        collection do
          get :get_current_user_bookmark
          post :get_bookmarks
        end
      end
      resources :reviews, only: [:create] do
        collection do
         post :review_filter
         post :get_reviews
       end
      end
      resources :support_conversations do
        post 'create_message'
        post 'get_messages'
      end
      resources :reporting do
        collection do
          post 'report_conversation'
        end
      end
     resources :notifications do
      collection do
        post :notification_token
      end
    end
     resources :conversations, only: [:create, :index, :destroy] do
      collection do
        post :notification_token
        post :read_messages
        post :logout
      end
    end
     resources :messages, only: [:create, :destroy] do
      collection do
        post :get_messages
        get :get_notification
        delete :delete_notification
      end
    end
    resources :dream_addresses do
        collection do
          get :fetch_address
        end
      end
      resources :user_preferences, only: [:create, :index] 
      get '/*a', to: 'api#not_found'
      post "/active", to: 'users_lists#index'

    end
  end
end
