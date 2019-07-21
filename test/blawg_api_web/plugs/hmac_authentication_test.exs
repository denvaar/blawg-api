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
    valid_hash = "18d35e75944596b53a22c4af1427bf9c7c7a059e8a85f33a2407c2b9c03cc0f8"

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    refute conn.status == 401
  end

  test "allows a valid message through with nested params and numbers",
       %{plug_params: plug_params, create_article_path: create_article_path} do
    article_params = %{"article" => %{"title" => "yolo", "content" => 1}}
    valid_hash = "1759233acc01327de179509c2f30b21ae61efa9422f7f5945bba8b17131f7bd3"

    conn =
      Plug.Test.conn(:post, create_article_path, article_params)
      |> put_req_header("authorization", "hmac #{valid_hash}")
      |> BlawgApiWeb.Plugs.Authentication.call(plug_params)

    refute conn.status == 401
  end

  test "allows a valid message through with crazy params",
       %{plug_params: plug_params, create_article_path: create_article_path} do
    article_params = %{
      "article" => %{"title" => "yolo", "content" => 1},
      "z" => %{"crap" => %{"nested" => "ok"}}
    }

    valid_hash = "26157f2b2d06ecd7e7961a953557a1ed43546aeb375d509e53456e2e37f73d2f"

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
