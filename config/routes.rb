Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post '/new', to: 'my_models#create'
  put '/update/:id', to: 'my_models#update'

end
