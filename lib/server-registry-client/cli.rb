require 'thor'
require 'active_support/core_ext/object/blank'

module ServerRegistryClient
	class CLI < ::Thor
		class_option :server, :type => :string

		option :hostname
		option :ip_address
		option :port, :type => :numeric
		option :categories, :required => true, :banner => "comma-separated string of category names"
		desc "add_server", "add server to registry server"
		def add_server
			if options[:server].blank?
				raise ::Thor::RequiredArgumentMissingError, "--server must not be blank"
			end

			if options[:hostname].blank? && options[:ip_address].blank?
				raise ::Thor::RequiredArgumentMissingError, "--hostname or --ip_address must not be blank"
			end

			server = ServerRegistryClient::Server.new
			server.hostname = options[:hostname]
			server.ip_address = options[:ip_address]
			server.port = (options[:port].to_i > 0 ? options[:port].to_i : nil)

			categories = []

			categories << options[:categories].split(",")
			categories.flatten!

			client = ServerRegistryClient::Client.new(options[:server])
			client.add_server_to_categories(server, categories)
		end


	end
end