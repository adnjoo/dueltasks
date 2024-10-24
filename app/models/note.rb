class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :user

  # After saving the note, schedule the penalty check if the deadline is changed
  after_save :schedule_penalty_check, if: :deadline_changed?


  validates :title, presence: true

  def schedule_penalty_check
    # Schedule PenaltyWorker to run 1 minute after the deadline
    PenaltyWorker.perform_at(self.deadline + 1.minute, self.id)
  end
end
