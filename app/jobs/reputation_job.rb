class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    # передается не объект а ссылка / не ассоциации
    # perform_now - выполнит задачу
    # perform_later - поместит в очередь. чтобы исполнить в очереди нужен адаптер к примеру sidekiq
    Reputation.calculate(object)
  end
end
