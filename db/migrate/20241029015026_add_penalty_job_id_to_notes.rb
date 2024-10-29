class AddPenaltyJobIdToNotes < ActiveRecord::Migration[7.2]
  def change
    add_column :notes, :penalty_job_id, :string
  end
end
