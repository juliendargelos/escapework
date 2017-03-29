class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::UnknownController, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found

    private
        def authorize message = nil, type = :notice
            unless current_user?
                flash[type] = message unless message.nil?
                redirect_to create_session_path
            else
                true
            end
        end

		def unauthorize message = nil, type = :notice
            if current_user?
                flash[type] = message unless message.nil?
                redirect_to root_path
                false
            else
                true
            end
        end

        def current_user
            if session[:user_id]
                user = User.find_by(id: session[:user_id])
                if user
                    return @current_user ||= user
                else
                    session.delete :user_id
                end
            end
            nil
        end
        helper_method :current_user

		def current_user?
			current_user ? true : false
		end
		helper_method :current_user?

        def is_current_user? user
            if current_user
                user.id == current_user.id
			else
				false
            end
        end
        helper_method :is_current_user?

        def controller_is? *options
    		options.flatten!
    		options.map{ |option| option.to_s }.include? controller_name
    	end
        helper_method :controller_is?

    	def action_is? *options
    		options.flatten!
    		options.map{ |option| option.to_s }.include? action_name
    	end
        helper_method :action_is?

        def not_found
            @not_found = true
            @errors_controller = ErrorsController.new
            @errors_controller.request = request
            @errors_controller.response = response
            @errors_controller.http_404
        end

        def render_not_found
            not_found

            @code = @errors_controller.infos[:code]
            @error = @errors_controller.infos[:error]
            @message = @errors_controller.infos[:message]

            render 'errors/http.html.erb'
        end
end

