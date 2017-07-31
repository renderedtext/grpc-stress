defmodule ExClient do
  @moduledoc """
  Documentation for ExClient.
  """

  def server_run(port \\ 50051) do
    GRPC.Server.start(StressTest.StressService.Server, port)
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


  def benchmark_stress_call(time_sec, service_endpoint \\ default_endpoint()) do
    server_run(50052)

    {:ok, channel} = GRPC.Stub.connect(service_endpoint)
    request  = StressTest.StressResponse.new(reply: "qwerty")
    Benchee.run(
      %{
        "stress_call(endpoint) -> Ruby server" => fn -> stress_call(:endpoint, service_endpoint) end,
        "stress_call(channel) -> Ruby server" => fn -> stress_call(:channel, channel) end,
        "stress_call(request) -> Ruby server" => fn -> stress_call(:request, channel, request) end,
        "stress_call(endpoint) -> Elixir server" => fn -> stress_call(:endpoint, "localhost:50052") end,
      }, time: time_sec
    )
  end

  defp default_endpoint, do: "localhost:50051"
end
