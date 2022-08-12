class DailyDigest
  def send_digest
    new_questions_per_day = Question.created_or_updated_today

    User.find_each(batch_size: 10) do |user|
      DailyDigestMailer.digest(user, new_questions_per_day.to_a).deliver_later
    end
  end
end
