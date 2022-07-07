class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :rating
      t.belongs_to :user, null: false, foreign_key: true, default: 0
      t.belongs_to :votable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
