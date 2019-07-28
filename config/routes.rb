Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :carts, only: [:create], format: :json do
        resources :items_carts, only: [:index, :create], format: :json
      end
      resources :items, only: [:index], format: :json
    end
  end
end
