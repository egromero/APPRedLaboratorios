Rails.application.routes.draw do
  resources :laboratories
  resources :students
  get 'home_page/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home_page#index'
  resources :students do 
    get 'enrollment'
    post 'enroll'
  end
end
