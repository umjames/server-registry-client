require 'thor'
require 'active_support/core_ext/object/blank'

module ServerRegistryClient
	class CLI < ::Thor
		class_option :server, :type => :string, :banner => "URL of the server registry"

		option :hostname, :banner => "server hostname"
		option :ip_address, :banner => "server IP address"
		option :port, :type => :numeric, :banner => "server port"
		option :categories, :required => true, :banner => "comma-separated string of category names"
		desc "add_server", "add server to registry server"
		def add_server
			require_server_option
			require_server_hostname_or_ip_address

			server = construct_server_from_options

			categories = parse_csv(options[:categories])

			client = construct_client
			client.add_server_to_categories(server, categories)
		end

		option :hostname, :banner => "server hostname"
		option :ip_address, :banner => "server IP address"
		option :port, :type => :numeric, :banner => "server port"
		option :categories, :required => true, :banner => "comma-separated string of category names"
		desc "remove_server_from_category", "remove server from categories on registry server"
		def remove_server_from_category
			require_server_option
			require_server_hostname_or_ip_address

			server = construct_server_from_options

			categories = parse_csv(options[:categories])

			client = construct_client
			categories.each do |category_name|
				client.remove_server_from_category(server, category_name)
			end
		end

		option :hostname, :banner => "server hostname"
		option :ip_address, :banner => "server IP address"
		option :port, :type => :numeric, :banner => "server port"
		desc "remove_server", "remove all entries with the specified server attributes"
		def remove_server
			require_server_option
			require_server_hostname_or_ip_address

			server = construct_server_from_options

			client = construct_client
			client.remove_servers_like(server)
		end

		private

		def construct_client
			return ServerRegistryClient::Client.new(options[:server])
		end

		def construct_server_from_options
			server = ServerRegistryClient::Server.new
			server.hostname = options[:hostname]
			server.ip_address = options[:ip_address]
			server.port = (options[:port].to_i > 0 ? options[:port].to_i : nil)

			return server
		end

		def parse_csv(value)
			categories = []

			categories << value.to_s.split(",")
			categories.flatten!

			return categories
		end

		def require_server_hostname_or_ip_address
			if options[:hostname].blank? && options[:ip_address].blank?
				raise ::Thor::RequiredArgumentMissingError, "--hostname or --ip_address option must not be blank"
			end			
		end

		def require_server_option
			if options[:server].blank?
				raise ::Thor::RequiredArgumentMissingError, "--server options must not be blank"
			end			
		end
	end
end