require "spec_helper"
require_relative "../lib/stress_server"

class ServerRunner
  def initialize(service_impl)
    @service_impl = service_impl
  end

  def run
    @srv = GRPC::RpcServer.new
    port = @srv.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
    @srv.handle(@service_impl)

    @thd = Thread.new do
      @srv.run
    end
    @srv.wait_till_running
    port
  end

  def stop
    @srv.stop
    @thd.join
    fail 'server not stopped' unless @srv.stopped?
  end
end

RSpec.describe StressServer do

  after(:example) do
    @server.stop
  end

  it "says hi" do
    @server = ServerRunner.new(StressServer)
    @server.run

    stub = StressTest::StressService::Stub.new('localhost:50051', :this_channel_is_insecure)

    response = stub.stress_call(StressTest::StressRequest.new)

    message = response.reply

    expect(message).to eql("HopHup")
  end

end
