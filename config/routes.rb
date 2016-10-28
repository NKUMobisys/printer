Rails.application.routes.draw do
  root to: 'main#index'

  namespace :user do
    namespace :session do
      get 'new'
      get 'destroy'
    end
  end

  get 'main/index'

  post 'main/upload', as: 'upload'

  get 'login', to: "user/session#new", as: 'login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
