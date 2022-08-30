ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email, sortable: true
  set_property blend_chars: '@'

  # attrs
  has created_at, updated_at
end
