require File.join(File.dirname(__FILE__), 'spec_helper')

describe ServerRegistryClient::Client do
	it "should be a to create a client with a valid URL" do
		expect do
			client = ServerRegistryClient::Client.new("http://www.apple.com")
		end.to_not raise_error
	end

	it "should raise error if the client is given an invalid URL" do
		expect do
			client = ServerRegistryClient::Client.new("peorfpoefm")
		end.to raise_error
	end
end