Rails.application.routes.draw do
  root to: 'home#index'

  match '/auth/:provider/callback', to: 'auth#callback', via: %i[get post]
  delete '/sign_out', to: 'auth#sign_out'
end
