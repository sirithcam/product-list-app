Rails.application.routes.draw do
  namespace :api do
    namespace 'v1' do
      resources :products
      resources :tags
    end
  end

  resources :products
  root to: 'products#index'
end
