Ichigo::Application.routes.draw do
  constraints :subdomain=>'' do
    root :to=>'home#index'
    resources :orders,    :only=>[:create]
    resources :customers, :only=>[:show] do
      resources :orders,  :only=>[:index]
    end
  end
end
