class UsersController < ApplicationController
    before_action :set_user, only: :show
    before_action :authorize, only: [:show_current, :edit, :update, :destroy]
    before_action :unauthorize, only: [:create, :new]
    before_action :set_current_user, only: [:show_current, :edit, :update, :destroy]

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
            flash[:success] = 'Welcome!'
            redirect_to root_path
        else
            flash[:error] = 'Your registration has failed'
            render :new
        end
    end

	def edit
    end

    def update
        if @user.update user_params
            flash[:success] = 'Your informations have been saved'
            redirect_to edit_user_path
        else
            flash[:error] = 'Your changes have failed'
            render :edit
        end
    end

    def destroy
        @user.destroy
        session.delete :user_id

        flash[:success] = 'Your account has been deleted'
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
            params.require(:user).permit(:email, :password, :password_confirmation, :firstname, :lastname)
        end
end
