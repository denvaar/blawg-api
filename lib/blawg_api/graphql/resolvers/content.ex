defmodule BlawgApi.GraphQL.Resolvers.Content do
  alias BlawgApi.Persistance

  def list_articles(_parent, args, _resolution) do
    {:ok,
     Scrivener.paginate(
       Persistance.list_articles(),
       %{page: args.page, page_size: 3}
     )}
  end

  def get_article(_parent, args, _resolution) do
    {:ok, Persistance.get_article(args.slug)}
  end
end
