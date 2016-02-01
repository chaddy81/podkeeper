Rails.application.routes.draw do

  # get '/email_processor', to: proc { [200, {}, ["OK"]] }, as: 'mandrill_head_test_request'

  # mount_griddler
  # match '*path', to: 'static_pages#site_maintenance'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'test-facebook', to: 'sessions#facebook'

  resources :bulk_invites, only: [:new, :create]
  resources :calendar, only: [:index, :show] do
    get :calendar_events, on: :collection
  end
  resources :comments, only: [:create, :edit, :update, :destroy]
  resources :events do
    get 'duplicate'
    get 'confirm'
    get 'cancel'
    get 'export_to_ical'
    get 'export_to_personal_calendar'
    get 'clear_fields'
    get 'calendar_events', on: :collection
    get :update_last_visit, on: :collection
    get :cancel_notes_editing, on: :member
    get :edit_notes, on: :member
    patch :update_notes, on: :member
    patch :update_duplicate, on: :member
  end
  resources :calendar, only: :index
  resources :email_notifications, only: :create
  resources :event_notes, only: [:new, :create]
  resources :invalid_emails, only: :destroy
  resources :invites, only: [:index, :create, :destroy] do
    get :accept, on: :member
    get :decline, on: :member
    get :pod_preview, on: :member
    get :decline_pod, on: :member
  end
  resources :invite_requests, only: :create
  resources :kids, except: [:index, :show]
  resources :lists do
    get :notify_pod, on: :member
    get :add_list_item, on: :member
    get :update_last_visit, on: :collection
  end
  resources :list_items, except: [:index, :show] do
    get :cancel, on: :member
  end
  resources :notes do
    get :update_last_visit, on: :collection
  end
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'no_pod', to: 'pods#no_pod', as: :no_pod
  resources :pods, except: :index do
    get 'new_with_code'
    get 'show_past_events'
    get 'switch'
    post 'create_user_and_pod'
    get :set_pod, on: :collection
    get :set_current_pod, on: :member
    get  :details, on: :collection
  end
  resources :pod_memberships, only: [:index, :edit, :update, :destroy] do
    post :reassign_organizer, on: :member
  end
  resources :reminders, only: [:create, :index]
  resources :rsvps, only: [:create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :settings, only: [:edit, :update]
  resources :site_comments, only: [:new, :create]
  resources :uploaded_files do
    get :update_last_visit, on: :collection
  end
  resources :users, only: [:new, :create, :edit, :update] do
    get :pods, on: :member
    post :seen_splash_message, on: :collection
    post :seen_get_pod_going, on: :collection
  end

  get '/thank_you', to: 'users#thank_you', as: 'thank_you'

  resources :unbounce, only: :create

  resources :registrations, only: :new

  get 'invite-others', to: 'bulk_invites#new', as: 'invite_others'

  get 'event_sort', to: 'events#sort'

  get 'note_sort', to: 'notes#sort'
  get 'note_sort_by_event_name', to: 'notes#sort_by_event'

  get 'reset_password_from_email/:id', to: 'password_resets#edit_from_email', as: 'reset_password_from_email'

  post 'pods/update_pod_sub_category/:id', to: 'pods#update_pod_sub_category', as: 'update_pod_sub_category'
  get 'members', to: 'pods#members'
  get 'register', to: 'pods#new_with_code'

  get 'login',  to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  get 'basketball',          to: 'landing_pages#basketball'
  get 'basketball_gaw',      to: 'landing_pages#basketball_gaw'
  get 'basketball_fba',      to: 'landing_pages#basketball_fba'
  get 'certifikid',          to: 'landing_pages#certifikids'
  get 'shared_calendar', to: 'landing_pages#shared_calendar'
  get 'shared_calendar_gaw', to: 'landing_pages#shared_calendar_gaw'

  get 'no_script',        to: 'static_pages#no_script'
  get 'about',            to: 'static_pages#about'
  get 'blog',             to: 'static_pages#blog'
  get 'faq',              to: 'static_pages#faq'
  get 'advertise',        to: 'static_pages#advertise'
  get 'privacy-policy',   to: 'static_pages#privacy_policy',   as: 'privacy_policy'
  get 'terms-of-service', to: 'static_pages#terms_of_service', as: 'terms_of_service'
  get 'our-mission',      to: 'static_pages#our_mission',      as: 'our_mission'
  get 'contact-us',       to: 'static_pages#contact',          as: 'contact'
  get 'mobile',           to: 'static_pages#mobile'
  get 'site_maintenance', to: 'static_pages#site_maintenance'
  get 'disable-tracking', to: 'static_pages#disable_tracking', as: 'disable_tracking'
  get 'overview',         to: 'static_pages#how_pods_work',    as: 'overview'
  get 'get-started',      to: 'static_pages#get_started',      as: 'get_started'
  get 'video',            to: 'static_pages#video',            as: 'video'
  get 'feedback',         to: 'site_comments#new',             as: 'feedback'
  post 'create_feedback', to: 'feedbacks#create'

  get 'signup',           to: 'registrations#new'
  post 'update_time_zone', to: 'users#update_time_zone'
  get 'update_fb_time_zone', to: 'users#update_fb_time_zone'
  get 'settings',         to: 'users#edit'

  root to: 'static_pages#index'

  get '*path', to: 'application#render_404'

end
