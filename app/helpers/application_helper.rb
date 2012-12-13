module ApplicationHelper
	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			""
		end
	end
	def gravatar(email, size)
		gravatar_id = Digest::MD5::hexdigest(email).downcase
	end
end
