defmodule BlawgApiWeb.Plugs.AuthenticationTest do
  use BlawgApiWeb.ConnCase

  alias BlawgApiWeb.Router.Helpers, as: Routes

  setup _context do
    plug_params = %{authentication_handler: BlawgApi.HmacAuthentication}
    create_article_path = Routes.article_path(build_conn(), :create)
    %{plug_params: plug_params, create_article_path: create_article_path}
  end

  test "allows a valid message through",
  %{plug_params: plug_params, create_article_path: create_article_path} do

    article_params = %{"title" => "yolo", "content" => "heyo"}
    valid_hash = "19fe6847f458e8e19509340ec432ae2b7957f6fc73bae9e28ff21d7f4af563c8"

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    refute conn.status == 401
  end

  test "does not allow an invalid message through",
  %{plug_params: plug_params, create_article_path: create_article_path} do

    article_params = %{"title" => "changed", "content" => "heyo"}
    valid_hash = "f066e73a7b325d35f0249e8c6c5cc5ea53a3fe024efe1d9e0edec487389f7d1b"

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    assert conn.status == 401
  end

  test "does not allow an invalid hmac hash through",
  %{plug_params: plug_params, create_article_path: create_article_path} do

    article_params = %{"title" => "changed", "content" => "heyo"}
    invalid_hash = "a066e73a7b325d35f0249e8c6c5cc5ea53a3fe024efe1d9e0edec487389f7d1b"

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "hmac #{invalid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    assert conn.status == 401
  end

  test "not allowed through when no authorization request header present",
  %{plug_params: plug_params, create_article_path: create_article_path} do

    article_params = %{"title" => "changed", "content" => "heyo"}

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    assert conn.status == 401
  end

  test "not allowed through with a malformed authorization request header",
  %{plug_params: plug_params, create_article_path: create_article_path} do

    article_params = %{"title" => "changed", "content" => "heyo"}

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "butts")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    assert conn.status == 401
  end
end
