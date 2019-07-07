defmodule BlawgApi.HmacAuthentication do
  @behaviour BlawgApi.Authentication

  @impl BlawgApi.Authentication
  def digest(message) do
    :crypto.hmac(:sha256,
      Application.get_env(:blawg_api, :hmac_key), message)
    |> Base.encode16()
    |> String.downcase()
  end

  @impl BlawgApi.Authentication
  def should_permit_access?(conn, hmac_digest) do
    auth_headers = Plug.Conn.get_req_header(conn, "authorization")

    if Enum.count(auth_headers) > 0 do
      [_proto, hmac_message] =
        auth_headers
        |> List.first()
        |> String.split(" ")

      Plug.Crypto.secure_compare(hmac_digest, hmac_message)
    else
      false
    end
  end
end
