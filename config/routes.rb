Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  mount StripeEvent::Engine, at: '/webhooks'
  root 'dashboards#index'
  resources :supports do
    member do
      get :get_specific_chat
    end
    collection do
      get :update_ticket_status
    end
  end
  resources :sub_admins do
    member do
      get :deactive_admin
      get :active_admin
    end
  end
  resources :school_pins do
    collection do
    get 'get_school_pins'
  end
end
  resources :dashboards do
    post :index
    collection do
      get :notification_page
    end
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
  post 'privacy_policy/:permalink', to: 'guidelines#create'
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
      get :property_profile
    end
  end
  resources :users_lists do
    member do
      get :active_account
      get :deactive_account
      get :user_profile
    end
  end
  devise_for :admins,
  controllers: {
    passwords: 'admins/passwords'
  }
  get '/sp_active_account/:id', to: 'support_closers#active_user', as: 'sp_active_account'
  get '/sp_deactive_account/:id', to: 'support_closers#deactive_user',as: 'sp_deactive_account'
  get '/privacy_policy/:permalink', to: 'guidelines#guidelines', as: 'privacy_policy'

  namespace :api do
    namespace :v1 do

      post '/login', to: 'sessions#login'
      post '/logout', to: 'sessions#logout'

      post '/signup', to: 'registrations#create'
      post '/register_user', to: 'registrations#complete_registration'
      post '/verify_otp', to: 'registrations#verify_otp'
      post '/verify_otp/resend_otp', to: 'registrations#resend_otp'

      post '/forgot_password/email', to: 'forgot_password#forgot_password_through_email'
      post '/forgot_password/phone', to: 'forgot_password#forgot_password_through_phone'
      post '/reset_password/email', to: 'forgot_password#reset_password_with_email'
      post '/reset_password/phone', to: 'forgot_password#reset_password_with_phone'

      get '/show_profile', to: 'users#show_profile'
      get '/show_other_user_profile', to: 'users#show_other_user_profile'
      get '/profile_visitor_list', to: 'users#profile_visitor_list'
      put '/update_profile', to: 'users#update_profile'
      delete '/delete_account', to: 'users#delete_account'
      get '/search_support_closers', to: 'users#search_support_closers'
      get '/top_support_closers', to: 'users#get_highest_rated_support_closers'

      get 'blocked_users', to: 'users#blocked_users'
      get 'unblocked_users', to: 'users#unblocked_users'
      post 'block_unblock_user', to: 'users#block_unblock_user'
      post 'report_unreport_user', to: 'users#report_unreport_user'
      get 'reported_users', to: 'users#reported_users'
      post '/update_notification', to: 'users#update_notification'
      get '/get_notification_setting', to: 'users#get_notification_setting'
      put '/update_location', to: 'users#update_location'
      # post '/get_school', to: 'users#get_school'
      # post '/get_school_pins', to: 'users#get_school_pins'

      post '/create_card', to: 'payments#create_card'
      get '/get_packages', to: 'payments#get_packages'
      post '/create_package', to: 'payments#create_package'
      post '/create_subscription', to: 'payments#create_subscription'
      post '/cancel_subscription', to: 'payments#cancel_subscription'
      get '/get_subscription', to: 'payments#get_subscription'
      get '/get_subscription_history', to: 'payments#get_subscription_history'
      get '/get_card', to: 'payments#get_card'
      get '/get_all_cards', to: 'payments#get_all_cards'
      get '/get_default_card', to: 'payments#get_default_card'
      put '/set_default_card', to: 'payments#set_default_card'
      put '/update_card', to: 'payments#update_card'
      delete '/delete_card', to: 'payments#destroy_card'
      # post '/apple_pay', to: 'payments#apple_pay'

      get '/mark_as_read', to: 'notifications#mark_as_read'
      get '/get_user_notifications', to: 'notifications#get_user_notifications'
      delete '/delete_notification', to: 'notifications#delete_notification'

      get '/tickets', to: 'supports#get_tickets'
      post '/tickets', to: 'supports#create_ticket'

      post '/social_login', to: 'social_logins#social_login'
      get '/static_page/:permalink', to: 'static_pages#static_page'
      post '/active', to: 'users_lists#index'

      get '/show_current_user_setting', to: 'user_settings#show_current_user_setting'
      put '/update_current_user_setting', to: 'user_settings#update_current_user_setting'

      resources :properties, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :detail_options
          get :matching_properties
          get :find_in_circle
          get :find_in_polygon
          get :find_by_zip_code
          get :details_by_property_id
          # get :recent_properties
          # get :matching_property
          # get :matching_dream_address
        end
      end

      resources :dream_addresses, only: [:index, :create, :destroy]
      # resources :dream_addresses, only: [:index, :create, :destroy] do
      #   collection do
      #     post :fetch_property
      #     post 'fetch_user'
      #   end
      # end

      resources :saved_searches, except: [:new, :edit]
      resources :bookmarks, only: [:index, :create, :destroy]

      resources :user_preferences, only: [:index, :create] do
        collection do
          get '/potential_buyers', to: 'user_preferences#get_potential_buyer_preferences'
        end
      end
      resources :reviews, only: [:create] do
        collection do
          get :get_reviews
        end
      end
      resources :searched_addresses, only: [:create] do
        collection do
          get :get_users
        end
      end
      resources :support_conversations do
        collection do
          post :create_message
          post :get_messages
        end
      end
      resources :reporting do
        collection do
          post 'report_conversation'
        end
      end
      resources :conversations, only: [:create, :index, :destroy] do
        collection do
          post :check_conversation_between_users
          post :check_conversation_blocked_status
          post :read_messages
        end
      end
      resources :messages, only: [:create, :destroy] do
        collection do
          post :get_messages
        end
      end

      get '/*a', to: 'api#not_found'
    end
  end

end
