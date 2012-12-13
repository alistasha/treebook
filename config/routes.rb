Treebook::Application.routes.draw do
  get "profiles/show"

  as :user do
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users, skip: [:sessions]

  as :user do
    get "/login" => 'devise/sessions#new', as: :new_user_session
    post "/login" => 'devise/sessions#create', as: :user_session
    delete "/login" => 'devise/sessions#destroy', as: :destory_user_session
  end

  resources :user_friendships
  
  resources :statuses do
    resources :comments, :only => [:create, :destroy]
    resources :ratings, :only => [:create, :update, :destroy]   
  end
  get 'feed', to: 'statuses#index', as: :feed

  # To the left of the pound is the controller(statuses) and the action(index)
  root :to => "statuses#index"

  # we pass in the variable that we want to go into the params hash.
  # In this case, it's ID, because that's what we're finding as the profile name. 
  get '/:id', to:'profiles#show', as: 'profile'
end
