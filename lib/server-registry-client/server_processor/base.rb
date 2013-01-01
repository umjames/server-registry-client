require 'typhoeus'
require 'uri'
require 'yajl'

module ServerRegistryClient
	module ServerProcessor
		class Base
			attr_reader :server_registry_url_root
			attr_reader :last_response

			def initialize(server_registry_url_root)
				@server_registry_url_root = server_registry_url_root
				@hydra = ::Typhoeus::Hydra.new
			end

			protected

			attr_reader :hydra

			def default_typhoeus_options
				{
					:timeout => 5000
				}
			end

			def make_web_request(api_fragment, options={}, &block)
				typhoeus_options = default_typhoeus_options.merge(options)

				request = ::Typhoeus::Request.new(URI.join(self.server_registry_url_root, api_fragment).to_s, typhoeus_options)
				response_body = nil

				request.on_complete do |response|
					if response.timed_out?
						raise ServerRegistryClient::ServerCommunicationError, "Request to #{request.url} timed out"
					elsif response.success?
						if response.headers["Content-Type"] == "application/json"
							response_body = parse_json(response.body)
						else
							response_body = response.body
						end
					end
				end

				self.hydra.queue(request)
				self.hydra.run

				@last_response = request.response

				unless block.nil?
					block.call(self.last_response, response_body)
				end

				return response_body
			end

			def print_typhoeus_response(response)
				return <<-EOF
					#{response.code} #{response.status_message}
					#{response.headers}

					#{response.body}
				EOF
			end

			def parse_json(data)
				json = Yajl::Parser.parse(data, :symbolize_keys => true)
				return json
			end

			def jsonify(data)
				return Yajl::Encoder.encode(data, :pretty => true)
			end
		end
	end
end