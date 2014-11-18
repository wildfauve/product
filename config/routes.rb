Rails.application.routes.draw do
  root :to => "sales_products#index"
  
  resources :sales_products
  
  namespace :api do
    namespace :v1 do
      resources :sales_products do
        resources :originations
      end
      
    end
  end
  
  
end
