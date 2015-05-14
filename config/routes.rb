Rails.application.routes.draw do
  root :to => 'users#index'
  get 'home' => 'layouts#index'
  
  #get 'connections/index'
  get 'connections/ranges/:start_date/:end_date/:unique_visitors/:max/:min(/:start_hour/:end_hour)' => 'connections#ranges'
  get 'connections/connections_between_dates/:start_date/:end_date/:group_by/:unique_visitors(/:start_hour/:end_hour)' => 'connections#connections_between_dates'
  get 'connections/total_seconds/:start_date/:end_date(/:start_hour/:end_hour)' => 'connections#total_seconds'
  get 'connections/avg_seconds/:start_date/:end_date(/:start_hour/:end_hour)' => 'connections#avg_seconds'
  get 'connections/total_seconds_grouped/:start_date/:end_date/:group_by(/:start_hour/:end_hour)' => 'connections#total_seconds_grouped'
  get 'connections/programs/:start_date/:end_date/:unique_visitors(/:start_hour/:end_hour)' => 'connections#programs'

  post 'login' => 'users#create'
  get 'logout' => 'users#destroy'
  get 'login_form' => 'users#login_form'
  resources :users

  get 'locations/countries/:start_date/:end_date/:unique_visitors(/:start_hour/:end_hour)' => 'locations#countries'
  get 'locations/countries_time/:start_date/:end_date(/:start_hour/:end_hour)' => 'locations#countries_time'

  get 'ranking/country_ranking/:start_date/:end_date(/:start_index/:count)(/:start_hour/:end_hour)' => 'ranking#country_ranking'

  get 'sources' => 'sources#get_sources'
  post 'sources/:source' => 'sources#set_source', :constraints => {:source => /([a-zA-Z0-9].*)+\.[a-zA-Z0-9]+|Todos/}
  resources :sources

  get 'poll/:route' => "polling#poll", :constraints => {:route => /.*/}

  # Establecemos una expresion regular para decirle a Rails que en el parametro "source" deje pasar valores del tipo "nombre.extension"
  #map.resources :sources, :requirements => { :source => /[a-z]+\.[a-z]+/}

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
