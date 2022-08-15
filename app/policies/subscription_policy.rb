class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def create?
    user&.admin? || user
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end
end
