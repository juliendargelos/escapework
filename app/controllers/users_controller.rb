class UsersController < ApplicationController
    before_action :set_user, only: :show
    before_action :authorize, only: [:show_current, :edit, :update, :destroy]
    before_action :unauthorize, only: [:create, :new]
    before_action :set_current_user, only: [:show_current, :edit, :update, :destroy]
	before_action only: [:index] { authorize only: :teacher }
	before_action :allow_changes_for_teacher, only: [:edit, :update, :destroy]

	def index
		@users = User.all
	end

    def show
    end

    def show_current
        redirect_to action: :show, id: @user.id
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new user_params

        if @user.save
            session[:user_id] = @user.id
            flash[:success] = 'Bienvenue '+@user.firstname+' !'
            redirect_to root_path
        else
            flash[:error] = 'Impossible de vous enregistrer'
            render :new
        end
    end

		def edit
    end

    def update
        if @user.update user_params
            flash[:success] = 'Vos informations ont bien été enregistrées'
            redirect_to edit_user_path
        else
            flash[:error] = 'Impossible d\'enregistrer vos informations'
            render :edit
        end
    end

    def destroy
        @user.destroy
        session.delete :user_id

        flash[:notice] = 'Votre compte a bien été supprimé'
        redirect_to root_path
    end

    private
        def set_user
            @user = User.find params[:id]
        end

        def set_current_user
            @user = current_user
        end

        def user_params
            attributes = [:email, :password, :password_confirmation, :firstname, :lastname]
            attributes += [:status] if current_user? is: :teacher

            params.require(:user).permit(*attributes)
        end

		def allow_changes_for_teacher
			if params.key?(:id)
				if current_user? is: :teacher
					set_user
				else
					flash[:error] = 'Accès refusé'
					redirect_to root_path
					return false
				end
			end
		end
end
