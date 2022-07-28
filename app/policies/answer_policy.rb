class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def update?
    user.admin? || user == record.user
  end
end
