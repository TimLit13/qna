class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :find_link, only: :destroy

  def destroy
    @link.destroy if current_user&.author_of?(@link.linkable)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
