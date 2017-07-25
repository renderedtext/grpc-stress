defmodule ExClient do
  @moduledoc """
  Documentation for ExClient.
  """

  def server_run() do
    GRPC.Server.start(StressTest.StressService.Server, 50051)
  end

  def stress_call(:endpoint, service_endpoint) do
    {:ok, channel} = GRPC.Stub.connect(service_endpoint)
    stress_call(:channel, channel)
  end
  def stress_call(:channel, channel) do
    request  = StressTest.StressResponse.new(reply: "qwerty")
    stress_call(:request, channel, request)
  end
  def stress_call(:request, channel, request) do
    channel |> StressTest.StressService.Stub.stress_call(request)
  end


  def benchmark_stress_call(service_endpoint \\ default_endpoint()) do
    {:ok, channel} = GRPC.Stub.connect(service_endpoint)
    request  = StressTest.StressResponse.new(reply: "qwerty")
    Benchee.run(
      %{
        "stress_call(endpoint)" => fn -> stress_call(:endpoint, service_endpoint) end,
        "stress_call(channel)" => fn -> stress_call(:channel, channel) end,
        "stress_call(request)" => fn -> stress_call(:request, channel, request) end
      }, time: 5
    )
  end

  defp default_endpoint, do: "localhost:50051"
end
