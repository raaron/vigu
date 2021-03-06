Vigu::Application.routes.draw do


  scope "(:locale)", :locale => /de|en|es/ do
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :paragraphs

    resources :translations

    namespace :admin do
      resources :news do
        collection do
          post :sort
        end
      end

      resources :partners do
        collection do
          post :sort
        end
      end

      match 'about',              to: 'about#edit'
      match 'about/update',       to: 'about#update'

      match 'home',              to: 'home#edit'
      match 'home/update',       to: 'home#update'
      match '/',               to: 'home#edit'
      match '/home/sort',               to: 'home#sort', :via => :post

      match 'switch_to_admin_view',        to: 'application#switch_to_admin_view'
      match 'switch_to_normal_view',        to: 'application#switch_to_normal_view'
    end


    root to: "home#show"

    match 'news',               to: 'news#index'
    match 'partners',               to: 'partners#index'
    match 'about',               to: 'about#show'
    match 'home',               to: 'home#show'

    match '/register',          to: 'users#new'
    match '/login',             to: 'sessions#new'
    match '/logout',            to: 'sessions#destroy', via: :delete

    match 'development/roadmap', to: 'development#roadmap'
    match 'development/todo',    to: 'development#todo'
    match 'development/done',    to: 'development#done'
  end

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
