defmodule BlawgApi.Persistance do
  @moduledoc """
  Data persistance boundary.
  """

  @persistance_handler Application.get_env(:blawg_api, :persistance_handler)

  defdelegate create_article(params), to: @persistance_handler
  defdelegate update_article(slug, params), to: @persistance_handler
  defdelegate get_article(slug), to: @persistance_handler
  defdelegate list_articles(), to: @persistance_handler
  defdelegate delete_article(slug_or_id), to: @persistance_handler
end
