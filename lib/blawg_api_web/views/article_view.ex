defmodule BlawgApiWeb.ArticleView do
  use BlawgApiWeb, :view

  alias BlawgApiWeb.ArticleView

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{article: render_one(article, ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{slug: article.slug}
  end
end
