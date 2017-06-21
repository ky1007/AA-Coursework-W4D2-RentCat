Rails.application.routes.draw do
  resources :cats, only: [:index, :show, :create, :new, :update, :edit]
  resources :cat_rental_requests, only: [:new, :create]
end
