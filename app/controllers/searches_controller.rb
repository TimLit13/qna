class SearchesController < ApplicationController
  def index
    service = SearchService.new
    @search_results = service.call(query_params)
  end

  private

  def query_params
    params.permit(:query)
  end
end
