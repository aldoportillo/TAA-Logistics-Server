Rails.application.routes.draw do
  resources :ports
  resources :pricing_matrices
  resources :inquiries
  resources :applications
  resources :quotes
  devise_for :users

  resources :events do
    resources :images, only: [:create, :destroy]
  end


  get 'dashboard', to: 'dashboard#index', as: 'admin_dashboard'
  post 'dashboard/mass_message', to: 'dashboard#mass_message', as: 'mass_message_admin'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :employees, controller: 'employees'
  
  resources :bids do
    collection do
      post :upload_csv
      get  :download_processed
    end
  end

  # Defines the root path route ("/")
  
  root to: "home#index"

  get '*path', to: redirect('/')
end
