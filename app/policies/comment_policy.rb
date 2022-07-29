class CommentPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def create?
    user&.admin? || user
  end
end
