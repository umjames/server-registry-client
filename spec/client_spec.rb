require File.join(File.dirname(__FILE__), 'spec_helper')

describe ServerRegistryClient::Client do
	it "should be able to create a client with a valid URL" do
		expect do
			client = ServerRegistryClient::Client.new("http://www.apple.com")
		end.to_not raise_error
	end

	it "should recognize localhost URLs" do
		expect do
			client = ServerRegistryClient::Client.new("http://localhost:3000/api/")
		end.to_not raise_error
	end
	
end