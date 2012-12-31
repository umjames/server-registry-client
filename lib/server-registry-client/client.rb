module ServerRegistryClient
	class Client
		def initialize(server_registry_url)
			raise "You must provide a valid URL for the server registry server (#{server_registry_url})" unless url_is_valid?(server_registry_url)

			@server_registry_url = server_registry_url
		end

		protected

		def url_is_valid?(url)
			http_regexp = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

			return (url =~ http_regexp) == 0
		end
	end
end