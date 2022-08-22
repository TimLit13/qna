require 'rails_helper'

RSpec.describe SearchService do
  context 'search across all entities except All website' do
    SearchService::ENTITIES[0..-2].each do |search_entity|
      it "calls search for #{search_entity}" do
        query_from_page = { entity: search_entity, query: 'Query' }
        expect(search_entity.classify.constantize).to receive(:search).with(query_from_page[:query], order: :updated_at)

        described_class.new(query_from_page).call
      end
    end
  end

  context 'search across All website' do
    let!(:query_from_page) { { entity: 'All website', query: 'Query' } }
    it 'calls search for all website' do
      expect(ThinkingSphinx).to receive(:search).with(query_from_page[:query], order: :updated_at)

      described_class.new(query_from_page).call
    end
  end

  context 'does not search when query string is empty' do
    let!(:query_from_page) { { entity: 'All website', query: '' } }
    it 'does not call search for all website' do
      expect(ThinkingSphinx).to_not receive(:search)

      described_class.new(query_from_page).call
    end
  end
end
