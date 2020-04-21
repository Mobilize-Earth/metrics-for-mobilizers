require 'mail'
class EmailValidator < ActiveModel::EachValidator
	def validate(record)
        @value = record.email
        if @value != '' then
            unless @value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
                record.errors[:email] << ("is not an email")
            end
        end
	end
end