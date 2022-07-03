class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  GIST_PATTERN = 'https://gist.github.com'.freeze

  def gist?
    self.url.start_with?(GIST_PATTERN)
  end

  def gist_id
    self.url.split('/').last
  end
end
