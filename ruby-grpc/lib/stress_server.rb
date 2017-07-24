require_relative "stress_services_pb"

class StressServer < StressTest::StressService::Service
  def stress_call(request, _unused_call)
    StressTest::StressResponse.new(:reply => "HopHup")
  end
end
