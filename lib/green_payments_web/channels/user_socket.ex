defmodule GreenPaymentsWeb.UserSocket do
  use Phoenix.Socket


  transport :websocket, Phoenix.Transports.WebSocket,
      timeout: 45_000

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
