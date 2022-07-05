require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { is_expected.to validate_url_of(:url) }

  describe '.gist?' do
    context 'link is link to github gist' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:gist_link) { create(:link, :gist, linkable: question) }
      let(:google_link) { create(:link, :google, linkable: question) }

      it 'checks that link is link to gist' do
        expect(gist_link.gist?).to be_truthy
      end

      it 'checks that link is not link to gist' do
        expect(google_link.gist?).to be_falsy
      end
    end
  end

  describe '.gist_id' do
    context 'should return gist id' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:gist_link) { create(:link, :gist, linkable: question) }

      it 'returns gist id' do
        expect(gist_link.gist_id).to eql('463382278baa1715551a0392ce98341c')
      end
    end
  end
end
