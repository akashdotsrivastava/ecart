Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :carts, only: [:index, :create], format: :json do
        resources :items_carts, only: [:index, :create], format: :json
      end
      resources :items, only: [:index], format: :json
      resources :item_discounts, only: [:index], format: :json
    end
  end
  root to: "home#index"
end
