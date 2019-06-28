defmodule BlawgApi.HmacAuthentication do
  def digest(message) do
    IO.inspect(Application.get_env(:blawg_api, :hmac_key))
    :crypto.hmac(:sha256, Application.get_env(:blawg_api, :hmac_key), message)
    |> Base.encode16()
    |> String.downcase()
  end
end
