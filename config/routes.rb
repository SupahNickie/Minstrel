Auracle::Application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}

  resources :users, path: 'artists', only: [:index, :show, :edit, :update] do
    resources :playlists do
      member do
        put :whitelist
        patch :whitelist
        put :blacklist
        patch :blacklist
        put :unblacklist
        patch :unblacklist
        put :unwhitelist
        patch :unwhitelist
        get :view_blacklist
        get :list
      end
    end
    resources :albums do
      resources :songs, except: [:show] do
        member do
          get :rating
          put :vote
          patch :vote
        end
      end
    end
  end

  get '/playlists/try', to: 'playlists#try'
  post '/playlists/trial_create', to: 'playlists#trial_create'

  resources :users, path: 'users', only: [:profile, :edit_profile, :update_profile] do
    resources :playlists do
      member do
        put :whitelist
        patch :whitelist
        put :blacklist
        patch :blacklist
        put :unblacklist
        patch :unblacklist
        put :unwhitelist
        patch :unwhitelist
        get :view_blacklist
        get :list
      end
    end
    member do
      get :profile
      get :edit_profile
      put :update_profile
      patch :update_profile
    end
  end

  match 'about', to: 'home#about', via: [:get]
  root :to => 'home#home'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
