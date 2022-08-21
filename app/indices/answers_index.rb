ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes user.email, as: :author, sortable: true
  indexes question.title
  indexes question.body

  # attrs
  has user_id, created_at, updated_at
end
