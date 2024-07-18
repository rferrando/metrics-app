Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :metrics, only: [:create] do
    collection do
      post :generate_random_data
    end 
  end

  resources :metrics_aggregations, only: [] do
    collection do
      get :by_minute
      get :by_hour
      get :by_day
    end 
  end
end