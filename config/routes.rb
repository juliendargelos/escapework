Rails.application.routes.draw do
  root to: 'users#show_current'
  get '/logout' => 'sessions#destroy', as: :destroy_session
  post '/login' => 'sessions#create', as: :create_session
  get '/login' => 'sessions#new', as: :new_session
  post '/signup' => 'users#create', as: :create_user
  get '/signup' => 'users#new', as: :new_user
  scope '/user' do
    get '/' => 'users#show_current', as: :current_user
    get '/edit' => 'users#edit', as: :edit_user
    patch '/edit' => 'users#update', as: :update_user
    get '/destroy' => 'users#destroy', as: :destroy_user
	get '/:id' => 'users#show', as: :user
  end

  match '*path' => 'errors#http_404', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
