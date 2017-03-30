Rails.application.routes.draw do
    root to: 'pages#home'

    scope '/workshops' do
        get '/' => 'workshops#index', as: :workshops
        get '/new' => 'workshops#new', as: :new_workshop
        post '/new' => 'workshops#create', as: :create_workshop
        get '/:id' => 'workshops#show', as: :workshop
        get '/:id/edit' => 'workshops#edit', as: :edit_workshop
        patch '/:id/edit' => 'workshops#update', as: :update_workshop
        get '/:id/destroy' => 'workshops#destroy', as: :destroy_workshop

        scope '/:workshop_id/participations' do
            get '/' => 'participations#index', as: :participations
            get '/new' => 'participations#new', as: :new_participation
            post '/new' => 'participations#create', as: :create_participation
        end

        scope '/:workshop_id/problems' do
            get '/' => 'problems#index', as: :problems
            get '/new' => 'problems#new', as: :new_problem
            post '/new' => 'problems#create', as: :create_problem
        end
    end

    scope '/participations' do
        get '/:id/destroy' => 'participations#destroy', as: :destroy_participation
    end

    scope '/problems' do
        get '/:id' => 'problems#show', as: :problem
        get '/:id/edit' => 'problems#edit', as: :edit_problem
        patch '/:id/edit' => 'problems#update', as: :update_problem
        get '/:id/destroy' => 'problems#destroy', as: :destroy_problem
        patch '/:problem_id/answer' => 'answers#update', as: :update_answer
    end

    get '/logout' => 'sessions#destroy', as: :destroy_session
    post '/login' => 'sessions#create', as: :create_session
    get '/login' => 'sessions#new', as: :new_session
    post '/signup' => 'users#create', as: :create_user
    get '/signup' => 'users#new', as: :new_user

    scope '/user' do
        get '/' => 'users#show_current', as: :current_user
        get '(/:id)/edit' => 'users#edit', as: :edit_user
        patch '(/:id)/edit' => 'users#update', as: :update_user
        get '(/:id)/destroy' => 'users#destroy', as: :destroy_user
        get '/:id' => 'users#show', as: :user
    end

		get '/users' => 'users#index', as: :users

    match '*path' => 'errors#http_404', via: :all
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
