class SearchesController < ApplicationController
  def index
    service = SearchService.new(query_params)
    @search_results = service.call
  end

  private

  def query_params
    params.permit(:query, :entity)
  end
end
