Rails.application.routes.draw do
  
  root 'home_page#index'
  
  resources :flayers
  resources :laboratories
  resources :students
  resources :records 
  resources :visits
  devise_for :users

  resource :students do 
    post 'enroll'
    post 'created_from_totem'
  end
  
  resources :records do 
    collection {post :import}
  end
  
  resources :visits do 
    collection {post :import}
  end
  
  resources :students do 
    collection {post :import}
  end

  scope '/admin' do
    resources :users
    post 'users/new',to: "users#create"
    post 'users/reset_password',to: "users#reset_password"
  end
  

  get 'user/profile', to: "users#profile"
  get "/slideshow" => "slideshow#slideshow"
  get 'home_page/index'
  get '/expulse', to: "records#expulse", as: "button"
  get '/update_password', to: "utils#form_password"
  post '/update_password', to: "utils#update_password"
  get '/previous_records', to: "laboratories#previous_records"
  post '/get_records', to: "records#get_records"
  post '/get_student', to: "students#get_student"
  
end
