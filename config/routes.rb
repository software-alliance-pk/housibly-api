Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  root "dashboards#index"
  resources :supports
  resources :sub_admins do
    member do
      get :deactive_admin
      get :active_admin
    end
  end
  resources :school_pins
  resources :dashboards
  resources :support_closers do
    member do
      get :active_account
      get :deactive_account
    end
  end
  resources :guidelines do
    collection do
      get :job_lists
    end
  end
   resources :users_data do
    collection do
      get :buy_vacant_land
      get :buy_house
      get :buy_condo
    end
  end
  resources :users_lists do
    member do
      get :active_account
      get :deactive_account
    end
    collection do
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
      resources :properties, only: [:create, :get_all_cards, :update, :destroy, :index, :recent_property]
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
      post '/delete_card', to: 'payments#destroy_card'
      post '/register_user', to: 'registrations#update_personal_info'
      put '/update_profile', to: 'users#update_profile'
      get '/search_support_closer', to: 'users#search_support_closer'
      get 'get_support_closers', to: 'users#get_support_closers'
      get 'support_closer_profile', to: 'users#support_closer_profile'
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
      resources :reviews, only: [:create, :index] do
        collection do
         get :review_filter
       end
      end
      resources :support_conversations do
        post 'create_message'
        get 'get_messages'
      end

     resources :conversations, only: [:create, :index, :destroy]
     resources :messages, only: [:create, :index, :destroy]
      resources :user_preferences, only: [:create, :index]
      get '/*a', to: 'api#not_found'
      post "/active", to: 'users_lists#index'

    end
  end
end
