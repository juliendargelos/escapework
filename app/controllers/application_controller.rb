class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::UnknownController, with: :not_found
    rescue_from ActionController::RoutingError, with: :not_found

    # before_action :root_redirection

    private
        def root_redirection
            if ENV.key?('ROOT_REDIRECTION')
                redirection = ENV.fetch('ROOT_REDIRECTION').split ' '
                if request.host == redirection[0]
                    redirect_to 'http://'+redirection[1]+request.original_fullpath, status: 301
                end
            end
        end

        def is_current_user? users = [], options = {}
            if users.is_a?(Hash)
                options = users
                users = []
            elsif !users.is_a?(Array)
                users = [users]
            end

            users << @user if users.length == 0

            valid_users = true
            users.each do |user|
                unless user.is_a? User
                    valid_users = false
                    break
                end
            end

            return false unless valid_users

            if current_user?
                and_ = options.key?(:and) ? options[:and] : []
                and_ = [and_] unless and_.is_a? Array
                and_ = [true] if and_.length == 0
                and_condition = false
                and_.each { |c| and_condition = and_condition || (c.is_a?(Symbol) || c.is_a?(String) ? current_user.send(:"#{c.to_s}?") : c) }

                or_ = options.key?(:or) ? options[:or] : []
                or_ = [or_] unless or_.is_a? Array
                or_ = [false] if or_.length == 0
                or_condition = false
                or_.each { |c| or_condition = or_condition || (c.is_a?(Symbol) || c.is_a?(String) ? current_user.send(:"#{c.to_s}?") : c) }

                authorized_user = false
                users.each do |user|
                    if user.id == current_user.id
                        authorized_user = true
                        break
                    end
                end

                authorized_user && and_condition || or_condition
            else
                false
            end
        end
        helper_method :is_current_user?

        def authorize options = nil, message = nil, destination = nil, type = :notice
            options = {} unless options.is_a? Hash
            only = options.key?(:only) ? options[:only] : []
            only = [only] unless only.is_a? Array

            users = []
            current_pushed = false
            o = []
            only.each do |u|
                if u.is_a?(User) || u == :current
                    if u == :current
                        unless current_pushed
                            users << @user if @user.is_a? User
                            current_pushed = true
                        end
                    else
                        users << u
                    end
                else
                    o << u
                end
            end
            only = o

            unless users.length != 0 ? is_current_user?(users, or: only) : current_user?(is: only)
                flash[type] = message unless message == nil
                set_destination destination unless destination == nil

                redirect_to create_session_path
                false
            else
                true
            end
        end

        def unauthorize options = nil, message = nil, destination = nil, type = :notice
            options = {} unless options.is_a? Hash
            only = options.key?(:only) ? options[:only] : []

            if current_user? is: only
                flash[type] = message unless message == nil
                session[:destination] = destination unless destination == nil

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

        def current_team_in workshop
            if workshop.is_a?(Workshop) && current_user?
                current_team = nil
                current_user.participations.each do |participation|
                    if participation.workshop_id == workshop.id
                        current_team = participation.team
                        break
                    end
                end

                current_team
            else
                nil
            end
        end

        def current_team_in? workshop
            current_team_in(workshop) ? true : false
        end

        def current_user? options = {}
            if current_user
                is = options.key?(:is) ? options[:is] : true
                is = [is] unless is.is_a? Array
                is = [true] if is.length == 0
                condition = false
                is.each { |c| condition = condition || (c.is_a?(Symbol) || c.is_a?(String) ? current_user.send(:"#{c.to_s}?") : c) }

                condition
            else
                false
            end
        end
        helper_method :current_user?

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
