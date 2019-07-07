defmodule BlawgApiWeb.ArticleControllerTest do
  use BlawgApiWeb.ConnCase

  import Mox

  setup :verify_on_exit!
  setup :permit_authentication

  def permit_authentication(_context) do
    conn = build_conn()

    BlawgApi.MockAuthentication
    |> expect(:digest, fn(_message) ->
      "x"
    end)
    |> expect(:should_permit_access?, fn(%Plug.Conn{} = _conn, "x") ->
      true
    end)

    [conn: conn]
  end

  describe "index/2" do
    test "lists articles", %{conn: conn} do
      article = %{id: 1,
        slug: "slug",
        title: "title",
        content: "content",
        date_published: nil}

      BlawgApi.MockPersistance
      |> expect(:list_articles, fn() ->
        [struct(Perseus.Article.Article, Keyword.new(article))]
      end)

      response =
        conn
        |> get(Routes.article_path(conn, :index))
        |> json_response(200)

      assert response == %{"articles" => [%{"slug" => article.slug}]}
    end
  end

  describe "create/2" do
    test "creates a new article and returns slug", %{conn: conn} do
      BlawgApi.MockPersistance
      |> expect(:create_article, fn(%{"title" => _title, "content" => _content}) ->
        {:ok, %{slug: "test-title"}}
      end)

      params = %{title: "Test Title", content: "Test content ..."}

      response =
        conn
        |> post(Routes.article_path(conn, :create, params))
        |> json_response(201)

      assert response == %{"article" => %{"slug" => "test-title"}}
    end

    test "fails to create article and returns error", %{conn: conn} do
      expected_errors =
        %{"content" => ["can't be blank"],
          "title" => ["can't be blank"]}

      BlawgApi.MockPersistance
      |> expect(:create_article, fn(_params) -> {:error, expected_errors} end)

      response =
        conn
        |> post(Routes.article_path(conn, :create, %{}))
        |> json_response(400)

      assert response == %{"errors" => expected_errors}
    end
  end

  describe "update/2" do
    test "updates an existing article and returns slug", %{conn: conn} do
      BlawgApi.MockPersistance
      |> expect(:update_article, fn("some-title", %{"content" => "updated content"}) ->
        {:ok, %{slug: "some-title"}}
      end)

      params = %{"article" => %{"content" => "updated content"}}

      response =
        conn
        |> patch(Routes.article_path(conn, :update, "some-title", params))
        |> json_response(204)

      assert response == %{"article" => %{"slug" => "some-title"}}
    end

    test "fails to update an existing article and returns error", %{conn: conn} do
      expected_errors = %{"content" => ["can't be blank"]}

      BlawgApi.MockPersistance
      |> expect(:update_article, fn(_slug, _article_params) ->
        {:error, expected_errors}
      end)

      params = %{"article" => %{"content" => nil}}

      response =
        conn
        |> patch(Routes.article_path(conn, :update, "some-title", params))
        |> json_response(400)

      assert response == %{"errors" => expected_errors}
    end

    test "fails to update an existing article because it doesn't exist", %{conn: conn} do
      article_params = %{"content" => "blah"}
      slug = "some-title"

      BlawgApi.MockPersistance
      |> expect(:update_article, fn(^slug, ^article_params) ->
        :not_found
      end)

      response =
        conn
        |> patch(Routes.article_path(conn, :update, slug,
          %{"article" => article_params}))
        |> json_response(404)

      assert response == %{"errors" => ["article not found"]}
    end
  end

  describe "delete/2" do
    test "deletes an article", %{conn: conn} do
      slug = "a-slug"

      BlawgApi.MockPersistance
      |> expect(:delete_article, fn(^slug) ->
        :ok
      end)

      response =
        conn
        |> delete(Routes.article_path(conn, :delete, slug))
        |> json_response(200)

      assert response == %{"article" => %{"slug" => slug}}
    end

    test "not found with nonexistant slug", %{conn: conn} do
      slug = "a-slug"

      BlawgApi.MockPersistance
      |> expect(:delete_article, fn(^slug) ->
        :not_found
      end)

      response =
        conn
        |> delete(Routes.article_path(conn, :delete, slug))
        |> json_response(404)

      assert response == %{"errors" => ["article not found"]}
    end
  end
end
