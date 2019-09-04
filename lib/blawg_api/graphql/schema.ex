defmodule BlawgApi.GraphQL.Schema do
  use Absinthe.Schema
  import_types(BlawgApi.GraphQL.ContentTypes)

  alias BlawgApi.GraphQL.Resolvers

  query do
    @desc "List all articles"
    field :articles, type: :article_list do
      arg(:page, non_null(:integer))
      resolve(&Resolvers.Content.list_articles/3)
    end

    @desc "Details of an article"
    field :article, type: :article do
      arg(:slug, non_null(:string))
      resolve(&Resolvers.Content.get_article/3)
    end
  end
end
