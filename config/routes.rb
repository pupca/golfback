Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :resorts do
  	member do
  		get :categories
  	end
  end
end
