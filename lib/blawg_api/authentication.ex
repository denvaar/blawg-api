defmodule BlawgApi.Authentication do
  @moduledoc false

  @callback digest(binary()) :: binary()

  @callback should_permit_access?(Plug.Conn.t(), binary()) :: boolean()
end
