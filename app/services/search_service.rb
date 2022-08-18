class SearchService
  def call(query_from_page)
    ThinkingSphinx.search(query_from_page[:query])
  end
end
