Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'routes', to: 'routes#create'
  get 'routes/cheapest/:route', to: 'routes#cheapest'
end
