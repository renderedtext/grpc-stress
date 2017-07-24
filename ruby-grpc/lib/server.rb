require_relative "stress_server"

def main
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(StressServer)
  s.run_till_terminated
end

main
