class ActionView::Helpers::FormBuilder
	include ActionView::Helpers::CaptureHelper
	include ActionView::Helpers::TagHelper
	include ActionView::Context
	include ActionView::Helpers::TextHelper

	def has_error? method
		@object.errors.messages.key? method
	end

	def filled? method
		!@object.send(method).blank?
	end

	def errors method, &block
		if has_error? method
			errors = @object.errors.messages[method]
		else
			errors = []
		end

		html = ''

		if block_given?
			errors.each do |error|
				html += block.call error.ucfirst
			end

			html.html_safe
		else
			errors.map { |error| error.ucfirst }
		end
	end

	def range method, value = {}, options = {}
		value[:minimum] = 0 unless value.key? :minimum
		value[:maximum] = 10 unless value.key? :maximum
		options[:minimum] = 0 unless options.key? :minimum
		options[:maximum] = 10 unless options.key? :maximum

		html = '<div class="range"'
		html += ' data-minimum="'+options[:minimum].to_s+'"'
		html += ' data-maximum="'+options[:maximum].to_s+'"'
		html += ' data-minimum-value="'+value[:minimum].to_s+'"'
		html += ' data-maximum-value="'+value[:maximum].to_s+'"'
		html += '>'
		html += self.hidden_field :"#{method}[minimum]", class: :minimum
		html += self.hidden_field :"#{method}[maximum]", class: :maximum
		html += '</div>'

		html.html_safe
	end

	def field method, options = {}, &block
		data = {}
		if @object
			data[:error] = '' if options[:error] != false && has_error?(method)
			data[:filled] = '' if options[:filled] != false && filled?(method)
		end

		data[:filled] = '' unless data.key?(:filled) || options[:value].blank?

		text_label = options[:label]
		if options.key? :input
			input = options[:input].blank? ? false : options[:input]

			unless input == false
				lazy_inputs = {
					text: :text_field,
					file: :file_field,
					number: :number_field,
					textarea: :text_area
				}

				input = lazy_inputs[input] if lazy_inputs.key? input
			end
		else
			input = :text_field
		end

		error = @object ? options[:error_message] != true : false
		classname = 'field'+(options[:class].blank? ? '' : ' '+options[:class].to_s)

		if options[:params].is_a? Array
			params = options[:params]
		else
			params = [options.except(:class, :error, :filled, :label, :input, :error_message)]
			params.unshift nil if input == :select
		end

		content_tag :div, class: classname, data: data do
			if text_label.is_a?(String) || text_label.is_a?(Symbol)
				text_label = text_label.is_a?(String) ? text_label : I18n.t(text_label, text_label.to_s.humanize)
				concat label(text_label)
			elsif text_label != false
				concat label(method)
			end
			concat block.call if block_given?
			concat send(input, method, *params) if input
			concat error_tag(method) if error
		end
	end

	alias_method :base_select, :select
	def select method, options_tags = nil, options = {}, html_options = {}
		if options_tags.nil?
			if @object.class.defined_enums.key?(method.to_s)
				options_tags = @object.class.send(method.to_s.pluralize(2)).map do |k, v|
					[k.humanize, k]
				end

				options[:selected] = @object.send(method) unless options.key? :selected
			else
				method_s = method.to_s.singularize
				method_ids = (method_s+'_ids').to_sym
				if @object.methods.include? method_ids
					method = method_ids
					options_tags = method_s.camelize.constantize.all.map do |record|
						[record.to_s, record.id]
					end

					options[:selected] = @object.send method
					html_options[:multiple] = true
				end
			end
		end

		base_select method, options_tags, options, html_options
	end

	def error method, &block
		errors = errors method
		error = errors.length == 0 ? nil : errors[0]

		if error == nil
			''
		elsif block_given?
			block.call error.ucfirst
		else
			error.ucfirst
		end
	end

	def error_tag method, options = {}
		error method do |error|
			error_tag_for error, options
		end
	end

	def error_tags method, options = {}
		errors method do |error|
			error_tag_for error, options
		end
	end

	def label_link method, path, options = {}
		record = @object.class.name.downcase
		id = record+'_'+method.to_s.gsub(/[\[\]]/, '_').gsub(/_+\z/, '')
		label = CGI.escapeHTML(I18n.t(:"activerecord.attributes.#{record}.#{method}"))
		link = "<a href=\"#{path.gsub '"', '\\"'}\">"

		if options.key? :only
			only = options[:only]
			only = I18n.t(only, only.to_s.humanize) if only.is_a? Symbol
			only = CGI.escapeHTML(only)
			content = label.gsub /(#{Regexp.escape(only)})/i, link+'\1</a>'
		else
			content = link+label+'</a>'
		end

		"<label for=\"#{id.gsub '"', '\\"'}\">#{content}</label>".html_safe
	end

	alias_method :base_check_box, :check_box
	def check_box method, options = {}
		options[:include_hidden] = false unless options.key :include_hidden

		base_check_box method, options
	end

	private
		def error_tag_for e, options
			tag_name = options.key?(:tag) ? options[:tag] : :span
			options.delete :tag
			options[:class] = :error unless options.key? :class

			html = "<#{tag_name}"
			options.each do |attribute, value|
				html += " #{attribute.to_s}=\"#{value.to_s.gsub '"', '\\"'}\""
			end
			html += ">#{CGI.escapeHTML e}</#{tag_name}>"

			html.html_safe
		end
end
