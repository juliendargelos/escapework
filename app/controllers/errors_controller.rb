class ErrorsController < ApplicationController
	def http_404
		@code = 404
		@message = "The page you were looking for doesn't exist"
		http
	end

	def http_402
		@code = 402
		@message = "The change you wanted was rejected"
		http
	end

	def http_500
		@code = 500
		@message = "We're sorry, but something went wrong"
		http
	end

	def http
		@http_error = true
		@error = @code.nil? ? "Unknown error" : "Error #{@code}"
		@message = "We're sorry, but something went wrong" if @message.nil?

		render 'http.html.erb'
	end

	def infos
		{
			code: @code,
			error: @error,
			message: @message
		}
	end
end
