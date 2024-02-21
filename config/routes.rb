Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  get 'homes/top'
  root to: "homes#top"
  get 'homes/about' => 'homes#about', as:'about'
  resources :books, only: [:new, :edit, :create, :index, :show, :destroy, :update] do
   resources :book_comments, only: [:create, :destroy]
   resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update]
  #退会確認画面
  get 'user/check' => 'users#check'#users/checkにするとshowのparamsに引っ掛かる エラーが出たときid="path"の前を確認
  #論理削除用のルーティング
  patch 'user/withdraw' => 'users#withdraw'
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
