defmodule BlawgApi.GraphQL.ContentTypes do
  use Absinthe.Schema.Notation

  object :article do
    field(:content, :string)
    field(:date_published, :string)
    field(:id, :id)
    field(:slug, :string)
    field(:title, :string)
  end

  object :article_list do
    field(:total_entries, :integer)
    field(:total_pages, :integer)
    field(:page_number, :integer)
    field(:page_size, :integer)
    field(:entries, list_of(:article))
  end
end
