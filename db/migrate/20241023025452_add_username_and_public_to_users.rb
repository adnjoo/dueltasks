class AddUsernameAndPublicToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :username, :string, null: true
    add_column :users, :public, :boolean, default: false

    # Add a unique index to the username column
    add_index :users, :username, unique: true, where: "username IS NOT NULL"
  end
end
