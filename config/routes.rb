EkBilling::Application.routes.draw do

  resources :documents

  root :to => 'admin#admin'

  match '/signup',             :to => "users#new"
  match 'user/login'           => "users#login",  :as => :login
  match 'user/logout'          => "users#logout", :as => :logout

  match 'horses/new/:customer' => 'horses#new',  :as => :new_horse_path

  match '/admin'               => "admin#admin",           :as => :admin
  match 'admin/send_emails'    => "admin#email_customers", :as => :send_emails

  get   'invoices/new'
  match 'invoices/email/:invoice'           => 'invoices#send_email',          :as => :invoice_email
  match 'invoices/text/:invoice'            => 'invoices#send_text',           :as => :invoice_text
  match 'invoices/paid/:invoice'            => 'invoices#mark_paid',           :as => :invoice_paid
  match 'invoices/confirm/:invoice'         => 'invoices#confirm_email',       :as => :invoice_confirm
  match 'invoices/request/:invoice'         => 'invoices#request_email',       :as => :invoice_request
  match 'invoices/mailed/:invoice'          => 'invoices#mark_mailed',         :as => :invoice_mailed
  match 'invoices/reminder/:invoice'        => 'invoices#reminder_email',      :as => :invoice_reminder

  match 'invoices/add_all_autos/:invoice'   => 'invoices#add_all_auto_items',  :as => :all_autos
  match 'invoices/add_auto/:invoice/:auto'  => 'invoices#add_single_auto_item',:as => :one_auto

  match 'autos/destroy/:id'                 => 'autos#destroy',                :as => :auto_delete
  match 'categories/destroy/:id'            => 'categories#destroy',           :as => :category_delete
  match 'customers/destroy/:id'             => 'customers#destroy',            :as => :customer_delete
  match 'documents/destroy/:id'             => 'documents#destroy',            :as => :document_delete
  match 'horses/destroy/:id'                => 'horses#destroy',               :as => :horse_delete
  match 'invoices/destroy/:id'              => 'invoices#destroy',             :as => :invoice_delete
  match 'items/destroy/:id'                 => 'items#destroy',                :as => :item_delete
  match 'payments/destroy/:id'              => 'payments#destroy',             :as => :payment_delete
  match 'users/destroy/:id'                 => 'users#destroy',                :as => :user_delete

  resources :customers do
    collection do
      get  :create_invoices
      post :build_invoices
    end
  end

  match 'customer/change',        :to => 'customers#change_delivery'
  match 'customer/create_invoices'    => 'customers#create_invoices', :as => :customer_invoices
  match 'customer/build_invoices'     => 'customers#build_invoices',  :as => :customer_builder

  match 'items/popup'   => 'items#popup', :as => :item_popup
  match 'items/new/:id' => 'items#new',   :as => :new_item_path

  resources :autos
  resources :categories
  resources :customers
  resources :horses
  resources :invoices
  resources :items
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
