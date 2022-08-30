class SearchService
  ENTITIES = %W[Question Answer Comment User #{'All website'}].freeze
  FULL_SEARCH = 'ThinkingSphinx'.freeze

  def initialize(query_from_page)
    @user_query_string = query_from_page[:query]
    @user_entity_name = query_from_page[:entity]
  end

  def call
    return [] if @user_query_string&.empty?

    if ENTITIES[0..-2].include?(@user_entity_name)
      perform_search(@user_entity_name, @user_query_string)
    else
      perform_search(FULL_SEARCH, @user_query_string)
    end
  end

  private

  def perform_search(entity_name, query_string)
    klass_name(entity_name).search(query_string, order: :updated_at)
  end

  def klass_name(entity)
    entity.classify.constantize
  end
end
