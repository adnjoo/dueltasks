class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :user

  # After saving the note, schedule the penalty check if the deadline is changed
  after_save :schedule_penalty_check

  validates :title, presence: true

  def schedule_penalty_check
    if self.saved_change_to_attribute?(:deadline)
      puts("Scheduling penalty check for note #{self.id}")
      # Schedule PenaltyJob to run 1 minute after the deadline
      PenaltyJob.perform_at(self.deadline + 1.minute, self.id)
    end
  end
end
