EkBilling::Application.routes.draw do

  root :to => 'pages#splash'
  match '/about',                   :to => 'pages#about'
  match '/builder',                 :to => 'pages#builder'
  match '/contact',                 :to => 'pages#contact'
  match '/home',                    :to => 'pages#home'

  match '/login'                    => 'users#login',                   :as => :login
  match '/logout'                   => 'users#logout',                  :as => :logout

  match 'pages/signup'              => 'pages#signup',                  :as => :signup
  match 'pages/access_denied'       => 'pages#access_denied',           :as => :access_denied

  match 'invoices/confirm/:id'      => "invoices#confirm",              :as => :invoice_confirm
  match 'invoices/request_mail/:id' => "invoices#request_mail",         :as => :invoice_request
  match 'invoices/issued/:id'       => "invoices#issued",               :as => :invoice_issued
  match 'invoices/text/:id'         => "invoices#text",                 :as => :invoice_text
  match 'invoices/mailed/:id'       => "invoices#mailed",               :as => :invoice_mailed
  match 'invoices/reminder/:id'     => "invoices#reminder",             :as => :invoice_reminder
  match 'invoices/paid/:id'         => "invoices#paid",                 :as => :invoice_paid

  match 'autos/destroy/:id'         => "autos#destroy",                 :as => :delete_auto
  match 'categories/destroy/:id'    => "categories#destroy",            :as => :delete_category
  match 'customers/destroy/:id'     => "customers#destroy",             :as => :delete_customer
  match 'documents/destroy/:id'     => "documents#destroy",             :as => :delete_document
  match 'horses/destroy/:id'        => "horses#destroy",                :as => :delete_horse
  match 'invoices/destroy/:id'      => "invoices#destroy",              :as => :delete_invoice
  match 'items/destroy/:id'         => "items#destroy",                 :as => :delete_item
  match 'organizations/destroy/:id' => "organizations#destroy",         :as => :delete_organization
  match 'payments/destroy/:id'      => "payments#destroy",              :as => :delete_payment
  match 'users/destroy/:id'         => "users#destroy",                 :as => :delete_user

  match 'customs/sample'            => "customs#sample",                :as => :invoice_sample

  match 'users/create_customer'     => "users#customer_acct_from_form", :as => :customer_from_form
  match 'users/create_manager'      => "users#manager_acct_from_form",  :as => :manager_from_form
  match 'users/new_customer/:id'    => "users#create_customer_account", :as => :new_customer_account
  match 'customers/validate/:id'    => "customers#validate_customer",   :as => :validate_customer
  match 'customers/update'          => "customers#update_info",         :as => :update_customer

  match 'payments/authorize/:id'    => "payments#authorize",            :as => :authorize
  match 'payments/creditcard/:id'   => "payments#creditcard",           :as => :creditcard
  match 'payments/relay_response'   => "payments#relay_response",       :as => :relay_response
  match 'payments/receipt/:id'      => "payments#receipt",              :as => :payment_receipt
  match 'payments/error'            => "payments#error",                :as => :payment_error

  match 'android/getAllCustomers', :to => "android#get_all_customers"

  resources :autos
  resources :categories
  resources :customers
  resources :customs
  resources :documents
  resources :horses
  resources :invoices
  resources :items
  resources :organizations
  resources :payments
  resources :users

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
