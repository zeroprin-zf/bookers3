Rails.application.routes.draw do
  devise_for :users
  get 'homes/top'
  root to: "homes#top"
  get 'homes/about' => 'homes#about', as:'about'
  resources :books, only: [:new, :edit, :create, :index, :show, :destroy, :update]
  resources :users, only: [:index, :show, :edit, :update]
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/seesions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
