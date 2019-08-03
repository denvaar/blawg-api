defmodule BlawgApiWeb.Plugs.Authentication do
  import Plug.Conn

  def init(_params) do
    %{}
  end

  def call(%{body_params: request_params} = conn, params) do
    authentication_handler =
      Map.get(
        params,
        :authentication_handler,
        Application.get_env(:blawg_api, :authentication_handler)
      )

    hmac_digest =
      request_params
      |> stringify_request_params()
      |> authentication_handler.digest()

    if authentication_handler.should_permit_access?(conn, hmac_digest) do
      conn
    else
      give_unauthorized_response(conn)
    end
  end

  def call(conn, _params) do
    give_unauthorized_response(conn)
  end

  defp give_unauthorized_response(conn) do
    conn
    |> put_status(401)
    |> Phoenix.Controller.json(%{"errors" => ["Unauthorized request"]})
    |> halt()
  end

  defp stringify_request_params(params) do
    # alphabetize all the keys and values of the
    # request params to check the hmac digest.

    params
    |> Map.to_list()
    |> flatten([])
    |> Enum.sort()
    |> Enum.join()
  end

  defp flatten([], result), do: result

  defp flatten([{key, value} | remaining], result) when is_map(value) do
    value
    |> Map.to_list()
    |> Kernel.++(remaining)
    |> flatten([key | result])
  end

  defp flatten([{key, value}], result), do: [key | [value | result]]

  defp flatten([{key, value} | remaining], result) do
    flatten(remaining, [key | [value | result]])
  end
end
