class CreateNotesUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :notes_users do |t|
      t.references :note, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
