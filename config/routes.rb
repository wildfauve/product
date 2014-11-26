Rails.application.routes.draw do
  root :to => "sales_products#index"
  
  resources :sales_products do
    resources :originations do
      member do
       put 'approval'
     end
    end
  end
  
  resources :algorithms do
    collection do
      post 'host_scan'
      get 'host_form'
    end
    member do
      put 'select'
    end
  end
  
  resources :tasks
  
  namespace :api do
    namespace :v1 do
      resources :sales_products do
        resources :originations do
          collection do
            get 'approval'
          end
        end
      end
      
    end
  end
  
  
end
