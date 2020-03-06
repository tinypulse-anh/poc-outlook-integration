Rails.application.routes.draw do
  root to: 'home#index'

  match '/auth/:provider/callback', to: 'auth#callback', via: %i[get post]
  delete '/sign_out', to: 'auth#sign_out'

  resources :calendar, only: :index do
    collection do
      post :subscribe
      post :unsubscribe
      post :change_callback
    end
  end
end
