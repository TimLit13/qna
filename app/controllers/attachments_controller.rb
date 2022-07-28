class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :find_attachment, only: :destroy

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    @attachment.purge if current_user&.author_of?(@attachment.record)
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
