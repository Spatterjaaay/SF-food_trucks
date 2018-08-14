Rails.application.routes.draw do
  get 'foodtruck/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/index', to: 'foodtruck#index'
end
