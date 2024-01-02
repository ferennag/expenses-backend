Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  scope :auth do
    post '/login', to: "auth#login"
    post '/logout', to: "auth#logout"
    post '/refresh', to: "auth#refresh"
  end

  scope '/user' do
    get '/profile', to: 'user#profile'
  end

  resources :workspaces do
    resources :categories
    resources :accounts do
      post '/transactions/import', to: 'transactions#import_transactions'

      resources :transactions
    end
  end
end
