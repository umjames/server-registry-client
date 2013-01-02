require File.join(File.dirname(__FILE__), 'spec_helper')

describe ServerRegistryClient::Server do
	context "matching algorithm" do
		before(:each) do
			@test_server = ServerRegistryClient::Server.new
			@test_server.id = 1
			@test_server.hostname = "localhost"
			@test_server.ip_address = "127.0.0.1"
			@test_server.port = 3000
		end

		it "should match if ids are the same" do
			server = ServerRegistryClient::Server.new
			server.id = 1
			server.hostname = "www.example.com"
			server.ip_address = "1.2.3.4"
			server.port = @test_server.port + 1
			
			@test_server.matches?(server).should be_true
		end

		it "should not match if the ports are different" do
			server = ServerRegistryClient::Server.new
			server.port = @test_server.port + 1

			@test_server.matches?(server).should_not be_true
		end

		it "should not match less specific server attributes" do
			server = ServerRegistryClient::Server.new
			server.hostname = @test_server.hostname

			@test_server.matches?(server).should_not be_true

			server.hostname = nil
			server.ip_address = @test_server.ip_address

			@test_server.matches?(server).should_not be_true

			server.hostname = @test_server.hostname

			@test_server.matches?(server).should_not be_true

			server.port = @test_server.port

			@test_server.matches?(server).should be_true
		end

		it "should match more specific server attributes" do
			server = ServerRegistryClient::Server.new
			server.hostname = @test_server.hostname

			server.matches?(@test_server).should be_true
			@test_server.matches?(server).should_not be_true

			server.hostname = nil
			server.ip_address = @test_server.ip_address

			server.matches?(@test_server).should be_true
			@test_server.matches?(server).should_not be_true

			server.hostname = nil
			server.ip_address = nil
			server.port = @test_server.port

			server.matches?(@test_server).should be_true
			@test_server.matches?(server).should_not be_true

			server.hostname = @test_server.hostname
			server.ip_address = @test_server.ip_address

			@test_server.matches?(server).should be_true
			server.matches?(@test_server).should be_true
		end

		it "should be able to find the correct servers" do
			servers = []

			server_to_match = ServerRegistryClient::Server.new(nil, "www.example.com")

			servers << ServerRegistryClient::Server.new(3, "stage.shindig.io", "4.3.2.1", 345)
			servers << ServerRegistryClient::Server.new(1, "www.apple.com", "1.2.3.4")
			servers << ServerRegistryClient::Server.new(8, "www.example.com")
			servers << ServerRegistryClient::Server.new(9, "www.example.com", nil, 80)
			servers << ServerRegistryClient::Server.new(10, "www.example.com", nil, 1221)
			servers << ServerRegistryClient::Server.new(2, "www.test.com", "1.2.3.4")

			found_servers = servers.find_all do |server|
				server_to_match.matches?(server)
			end

			found_servers.map(&:id).should == [8, 9, 10]
		end
	end
end