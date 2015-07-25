Rails.application.routes.draw do
  #resources :responders
  resources :responders, defaults: { format: :json  }
  resources :emergencies, defaults: { format: :json  }
  #resources :emergencies ,new: { index: :post }
end
