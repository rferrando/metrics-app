Rails.application.routes.draw do
  resources :metrics, only: [:create, :index] do
    collection do
      get :by_minute
      get :by_hour
      get :by_day
    end
  end
end
