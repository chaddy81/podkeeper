Rails.application.routes.draw do
  resources :events, only: [:index, :show]
  resources :pods, except: :index do
    get 'new_with_code'
    get 'show_past_events'
    get 'switch'
    post 'create_user_and_pod'
    get :set_pod, on: :collection
    get :set_current_pod, on: :member

    get  'invite'
    post 'create_invite'
    get  'details'
  end
  resources :notes do
    get :update_last_visit, on: :collection
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'signin',  to: 'static_pages#index'
  delete 'signout', to: 'sessions#destroy'

  root 'static_pages#index'
end
