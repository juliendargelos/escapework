class SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: :create
	before_action :authorize, only: :destroy
	before_action :unauthorize, only: [:new, :create]
	before_action :provide_email, only: [:create]

	def new
		@user = User.new(email: provided_email)
	end

	def create
		if session_params[:email] == '' || session_params[:password] == ''
			flash[:error] = 'Veuillez indiquer votre adresse email et votre mot de passe'
			redirect_to create_session_path
		else
			@user = User.find_by_email(session_params[:email])
			if @user && @user.authenticate(session_params[:password])
				session[:user_id] = @user.id
				forgive_email
				flash[:success] = 'Bienvenue '+@user.firstname+' !'
				redirect_to root_path
			else
				flash[:error] = 'Adresse email ou mot de passe incorrect'
				redirect_to create_session_path
			end
		end
	end

	def destroy
		session.delete :user_id
		flash[:notice] = 'Vous avez été déconnecté'
		redirect_to create_session_path
	end

	private
		def session_params
			params.require(:user).permit(:email, :password)
		end

		def provided_email
			session[:user_email]
		end

		def provide_email
			session[:user_email] = session_params[:email]
		end

		def forgive_email
			session.delete :user_email
		end
end
