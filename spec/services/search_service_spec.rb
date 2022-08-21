require 'rails_helper'

RSpec.describe SearchService do
  context 'search across all entities' do
    SearchService::ENTITIES.each do |search_entity|
      let!(:query_from_page) { { entity: search_entity, query: 'Query' } }
      subject { SearchService.new(query_from_page) }

      it "calls search for #{search_entity}" do
        expect_any_instance_of(SearchService).to receive(:call)

        subject.call
      end
    end
  end
end
