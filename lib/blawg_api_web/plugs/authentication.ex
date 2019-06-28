defmodule BlawgApiWeb.Plugs.Authentication do
  import Plug.Conn

  def init(_params) do
  end

  def call(%{params: %{"content" => content, "date" => date, "tags" => tags}} = conn, _params) do

    hmac_digest = BlawgApi.HmacAuthentication.digest(date <> content <> tags)

    [_proto, hmac_value] =
      conn
      |> get_req_header("authorization")
      |> List.first()
      |> String.split(" ")

    if Plug.Crypto.secure_compare(hmac_value, hmac_digest) do
      conn
    else
      conn
      |> put_status(401)
      |> Phoenix.Controller.json(%{"message" => "Unauthorized request"})
      |> halt()
    end
  end
end
