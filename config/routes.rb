Rails.application.routes.draw do
  
  root 'home_page#index'
  
  resources :flayers
  resources :machines
  resources :laboratories
  resources :students
  resources :records 
  resources :visits
  resources :wallets
  devise_for :users

  scope "/wallets/:student_id" do
    post "modify_wallet", to: "wallets#modify_wallet"
  end

  scope "machines" do
    get "/lab/:id", to: "machines#laboratories"
  end



  resources :reservations
  post "/occupied" => "reservations#occupied"
  get "/reservation" => "reservations#index"
  scope "reservation/:machine_id" do
    get "new", to: "reservations#new"
  end

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
  get '/get_laboratories_occupation', to: "records#get_occupation"
end
