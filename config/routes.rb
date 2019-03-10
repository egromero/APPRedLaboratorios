Rails.application.routes.draw do
  root 'home_page#index'
  devise_for :users
  resources :laboratories
  resources :students
  get 'home_page/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :students do 
    get 'enrollment'
    post 'enroll'
  end
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
end
