Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :players, only: [:show, :index]
    end
  end

  root "api/v1/players#index"
end
