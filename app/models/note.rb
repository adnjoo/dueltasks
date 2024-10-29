class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :user

  # After saving the note, schedule the penalty check if the deadline is changed
  after_save :schedule_penalty_check

  validates :title, presence: true

  def schedule_penalty_check
    if penalty_enabled && saved_change_to_attribute?(:deadline)
      # Cancel any existing job
      if penalty_job_id.present?
        Sidekiq::ScheduledSet.new.find_job(penalty_job_id)&.delete
      end

      # Schedule a new job and save its ID
      job_id = PenaltyJob.perform_at(self.deadline + 1.minute, self.id)
      update_column(:penalty_job_id, job_id)

      puts("Scheduled penalty check for note #{self.id}")
    end
  end

  before_destroy :cancel_penalty_job

  private

  def cancel_penalty_job
    if penalty_job_id.present?
      Sidekiq::ScheduledSet.new.find_job(penalty_job_id)&.delete
    end
  end
end
