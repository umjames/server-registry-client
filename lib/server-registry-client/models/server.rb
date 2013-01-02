require 'active_support/core_ext/object/blank'

module ServerRegistryClient
	class Server
		attr_accessor :id
		attr_accessor :hostname
		attr_accessor :ip_address
		attr_accessor :port

		def initialize(id=nil, hostname=nil, ip_address=nil, port=nil)
			@id = id
			@hostname = hostname
			@ip_address = ip_address
			@port = port
		end

		def matches?(server)
			result = false

			we_have_hostname = !self.hostname.blank?
			we_have_ip_address = !self.ip_address.blank?
			we_have_port = !self.port.blank?

			they_have_hostname = !server.hostname.blank?
			they_have_ip_address = !server.ip_address.blank?
			they_have_port = !server.port.blank?

			ip_address_matches = (we_have_ip_address && they_have_ip_address && self.ip_address == server.ip_address)
			hostname_matches = (we_have_hostname && they_have_hostname && self.hostname == server.hostname)

			port_matches = if we_have_port && they_have_port && self.port == server.port && (ip_address_matches || hostname_matches)
				true
			elsif they_have_port && !we_have_port && (ip_address_matches || hostname_matches)
				true
			elsif !they_have_port && !we_have_port && (ip_address_matches || hostname_matches)
				true
			elsif we_have_port && they_have_port && self.port == server.port && (!we_have_hostname && they_have_hostname)
				true
			else
				false
			end

			if self.id == server.id
				result = true
			else
				if ip_address_matches
					result = (true && port_matches)
				elsif hostname_matches
					result = (true && port_matches)
				else
					result = port_matches
				end
			end

			return result
		end
	end
end