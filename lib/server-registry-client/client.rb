module ServerRegistryClient
	class Client
		attr_accessor :server_processor

		def initialize(server_registry_url, version_number=1)
			use_version(server_registry_url, version_number)
		end

		def servers_in_category(category)
			return server_processor.servers_in_category(category)
		end

		def add_server_to_categories(server, category_names)
			return server_processor.add_server_to_categories(server, category_names)
		end

		def remove_server_from_category(server, category_name)
			return server_processor.remove_server_from_category(server, category_name)
		end

		def server_registry_url
			return server_processor.server_registry_url_root
		end

		protected

		def use_version(server_registry_url, version_number)
			raise "version number must be a number greater than zero" if version_number.to_i <= 0

			self.server_processor = ServerRegistryClient::ServerProcessor.const_get("V#{version_number}".to_sym).new(server_registry_url)
		end
	end
end