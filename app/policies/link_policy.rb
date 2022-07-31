class LinkPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def destroy?
    user&.admin? || user&.author_of?(record.linkable)
  end
end
