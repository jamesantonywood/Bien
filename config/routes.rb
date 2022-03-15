Rails.application.routes.draw do
  # resources sets up crud paths for the resource
  resources :reviews do 
    resources :comments
    resource :bookmark
  end

  resources :users

  resource :session

  # root of the whole site is the reviews index
	root "reviews#index"
end
