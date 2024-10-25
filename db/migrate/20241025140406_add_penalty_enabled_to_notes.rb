class AddPenaltyEnabledToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :penalty_enabled, :boolean
  end
end
