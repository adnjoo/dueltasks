class CreateNotesUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :notes_users do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # Adding a unique index to enforce uniqueness at the database level
    add_index :notes_users, [ :note_id, :user_id ], unique: true
  end
end
