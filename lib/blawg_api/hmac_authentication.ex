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
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> get_hmac_from_authorization_header()
    |> Plug.Crypto.secure_compare(hmac_digest)
  end

  defp get_hmac_from_authorization_header(["hmac " <> hmac]), do: hmac
  defp get_hmac_from_authorization_header(_), do: ""
end
