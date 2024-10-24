class AddDeadlineToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :deadline, :datetime
  end
end
