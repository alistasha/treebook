Treebook::Application.routes.draw do
  get "profiles/show"

  # If you have the need for more deep customization, for instance to also allow "/sign_in" besides "/users/sign_in",
  # all you need to do is to create your routes normally and wrap them in a devise_scope block in the router:
  # This way you tell devise to use the scope :user when "/sign_in" is accessed.
  # Notice devise_scope is also aliased as as in your router.
  # 마지막에 as helper를 이용하면 기존의 helper method의 이름을 수정할 수 있다.
  # 예를 들어, 기존의 new_user_registration_path를 register_path 로 수정할 수 있음
  as :user do
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  # http://rubydoc.info/github/plataformatec/devise/master/frames 참조
  
  devise_for :users, skip: [:sessions]

  as :user do
    get "/login" => 'devise/sessions#new', as: :new_user_session
    post "/login" => 'devise/sessions#create', as: :user_session
    delete "/login" => 'devise/sessions#destroy', as: :destory_user_session
  end

  # This is going to generate our routes for us.
  resources :user_friendships
  
  resources :statuses do
    resources :comments, :only => [:create, :destroy]
    resources :ratings, :only => [:create, :update, :destroy]   
  end
  get 'feed', to: 'statuses#index', as: :feed

  # Devise needs to know what the root URL to our site is even if there isn't one yet
  # To the left of the pound is the controller(statuses) and the action(index)
  # what that means is that as soon as we go to the root of our website, that's what's going to get displayed
  root :to => "statuses#index"

  # we pass in the variable that we want to go into the params hash.
  # In this case, it's ID, because that's what we're finding as the profile name. 
  get '/:id', to:'profiles#show', as: 'profile'
end
