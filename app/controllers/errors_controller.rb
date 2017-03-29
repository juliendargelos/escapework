class ErrorsController < ApplicationController
	def http_404
		@code = 404
		@message = "La page que vous recherchez n'existe pas"
		http
	end

	def http_402
		@code = 402
		@message = "Les modifications que vous avez demandées ont été rejetées"
		http
	end

	def http_500
		@code = 500
		@message = "Nous sommes désolés, mais quelque chose n'a pas fonctionné..."
		http
	end

	def http
		@http_error = true
		@error = @code.nil? ? "Erreur inconnue" : "Erreur #{@code}"
		@message = "Nous somme désolés, mais quelque chose n'a pas fonctionné" if @message.nil?

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
