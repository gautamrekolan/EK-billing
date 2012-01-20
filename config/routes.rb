EkBilling::Application.routes.draw do

  resources :organizations
  resources :users

  root :to => 'pages#home'
  match '/about',               :to => 'pages#about'
  match '/contact',             :to => 'pages#contact'

  match '/login'                    => 'users#login',           :as => :login
  match '/logout'                   => 'users#logout',          :as => :logout

  match 'organizations/destroy/:id' => "organizations#destroy", :as => :delete_organization
  match 'users/destroy/:id'         => "users#destroy",         :as => :delete_user

# match '/pagename' == pagename_path as named route

  # Method    URL           Action    Named Route       Purpose
  # GET       /users        index     users_path        Lists all users
  # GET       /users/1      show      user_path(1)      Shows user with id 1
  # GET       /users/new    new       new_user_path     Form to add a new user
  # POST      /users        create    users_path        Creates a new user
  # GET       /users/1/edit edit      edit_user_path(1) Form to edit user with id 1
  # PUT       /users/1      update    user_path(1)      Updates user with id 1
  # DELETE    /users/1      destroy   user_path(1)      Deletes user with id 1

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
