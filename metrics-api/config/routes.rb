Rails.application.routes.draw do
  resources :metrics, only: [:create, :index] do
  end
end
