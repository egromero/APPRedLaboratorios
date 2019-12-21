Rails.application.routes.draw do
  resources :flayers
  root 'home_page#index'

  get "/slideshow" => "slideshow#slideshow"
  devise_for :users
  scope '/admin' do
    resources :users
    post 'users/new',to: "users#create"
  end
  
  resources :laboratories
  resources :students
  get 'home_page/index'

  resource :students do 
    post 'enroll'
    post 'created_from_totem'
  end
  get '/expulse', to: "records#expulse", as: "button"

  resources :records 
  resources :laboratories do
    get 'new_admin'
    post 'set_admin'
  end
  resources :visits
 
  resources :records do 
    collection {post :import}
  end
  resources :visits do 
    collection {post :import}
  end
  resources :students do 
    collection {post :import}
  end
end
