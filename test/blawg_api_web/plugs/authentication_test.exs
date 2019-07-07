defmodule BlawgApiWeb.Plugs.AuthenticationTest do
  use BlawgApiWeb.ConnCase

  # alias BlawgApiWeb.Router.Helpers, as: Routes

  test "allows a valid message through" do
    plug_params = %{authentication_handler: BlawgApi.HmacAuthentication}
    article_params = %{"title" => "yolo", "content" => "heyo"}
    # valid_hash = "f066e73a7b325d35f0249e8c6c5cc5ea53a3fe024efe1d9e0edec487389f7d1b"
    valid_hash = "19fe6847f458e8e19509340ec432ae2b7957f6fc73bae9e28ff21d7f4af563c8"

    conn =
      Plug.Test.conn(:post, "/api/articles", article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    refute conn.status == 401
  end

  test "does not allow an invalid message through" do
    plug_params = %{authentication_handler: BlawgApi.HmacAuthentication}
    article_params = %{"title" => "changed", "content" => "heyo"}
    valid_hash = "f066e73a7b325d35f0249e8c6c5cc5ea53a3fe024efe1d9e0edec487389f7d1b"

    conn =
      Plug.Test.conn(:post, "/api/articles", article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    assert conn.status == 401
  end
end
