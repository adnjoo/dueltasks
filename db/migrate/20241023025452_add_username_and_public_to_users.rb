class AddUsernameAndPublicToUsers < ActiveRecord::Migration[7.2]
  def change
    # Allow username to be null
    add_column :users, :username, :string, null: true
    add_column :users, :public, :boolean, default: false

    # Add a unique index to the username column
    # Ensure the unique index allows multiple null values
    add_index :users, :username, unique: true, where: "username IS NOT NULL"
  end
end
