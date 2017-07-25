defmodule ExClient.Router do

  require Logger
  use Plug.Router


  plug Plug.Logger
#   plug Plug.Parsers, parsers: [:urlencoded, :json],
#                      pass:  ["*/*"],
#                      json_decoder: Poison

  plug :match
  plug :dispatch

  get "/ex-client" do
    send_resp(conn, 200, "Hello micro-service!")
  end

  get "/health_check/ping" do
    send_resp(conn, 200, "pong")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end
