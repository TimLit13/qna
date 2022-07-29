class QuestionPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def create?
    user&.admin? || user
  end

  def update?
    user&.admin? || user&.author_of?(record)
  end

  def destroy?
    user&.admin? || user&.author_of?(record)
  end

  def rate_up?
    user
  end

  def rate_down?
    user
  end

  def cancel_rate?
    user
  end
end
