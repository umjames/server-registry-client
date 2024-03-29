module ServerRegistryClient
	module ServerProcessor
		class V1 < Base
			def initialize(server_registry_url)
				super
				self.api_version = "v1"
			end

			def servers_in_category(category)
				response_json = make_web_request("/api/#{api_version}/category/#{category}")

				if response_json.nil? || last_response.response_code == 404
					return []
				else
					return response_json[:servers].map do |server_json|
						server_from_json(server_json)
					end
				end
			end

			def get_all_servers
				response_json = make_web_request("/api/#{api_version}/servers")
					
				return response_json.map do |server_json|
					server_from_json(server_json)
				end
			end

			def add_server_to_categories(server, category_names)
				server_json_hash = server_to_json_hash(server)
				server_json_hash[:categories] = (category_names.kind_of?(Array) ? category_names : [category_names])

				server_json = jsonify(server_json_hash)

				make_web_request("/api/#{api_version}/servers", {
					:method => :post,
					:body => server_json
				}) do |response, response_body|
					unless response.success?
						raise ServerRegistryClient::ServerCommunicationError, "Server responded: #{print_typhoeus_response(response)}"
					end
				end
			end

			def remove_server_from_category(server, category_name)
				server_name = server.hostname || server.ip_address
				server_removed = true

				make_web_request("/api/#{api_version}/category/#{category_name}/server/#{server_name}", {
					:method => :delete
				}) do |response, response_body|
					unless response.success?
						server_removed = false
					end
				end

				return server_removed
			end

			def remove_servers_like(server_to_match)
				all_servers = get_all_servers

				servers_to_delete = all_servers.find_all do |server|
					server_to_match.matches?(server)	
				end

				servers_to_delete.each do |server|
					make_web_request("/api/#{api_version}/server/#{server.id}", {
						:method => :delete
					})
				end
			end

			protected

			def server_from_json(server_json)
				server = ::ServerRegistryClient::Server.new

				server.id = server_json[:id]
				server.hostname = server_json[:hostname]
				server.ip_address = server_json[:ip_address]
				server.port = server_json[:port]

				return server
			end

			def server_to_json_hash(server)
				json = {}

				json[:hostname] = server.hostname
				json[:ip_address] = server.ip_address
				json[:port] = server.port

				return json
			end
		end
	end
end