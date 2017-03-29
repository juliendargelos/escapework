class BooleanValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    unless [true, false].include? value
      record.errors.add(attribute, options[:message] || :invalid)
    end
  end
end
