class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :notes_users, dependent: :destroy
  has_many :users, through: :notes_users

  after_save :schedule_penalty_check

  validates :title, presence: true

  # Helper methods to add and remove collaborators
  def add_collaborator(user)
    users << user unless users.include?(user)
  end

  def remove_collaborator(user)
    users.delete(user)
  end

  def collaborators
    users.where.not(id: owner.id)
  end

  def schedule_penalty_check
    if archived || !penalty_enabled
      cancel_penalty_job # Cancel the job if the note is archived
    elsif penalty_enabled
      # Cancel any existing job
      cancel_penalty_job

      # Schedule a new job and save its ID
      job_id = PenaltyJob.perform_at(deadline + 1.minute, id)
      update_column(:penalty_job_id, job_id)

      puts("Scheduled penalty check for note #{id}")
    end
  end

  private

  def cancel_penalty_job
    if penalty_job_id.present?
      job = Sidekiq::ScheduledSet.new.find_job(penalty_job_id)
      job&.delete
      Rails.logger.info("Penalty job #{penalty_job_id} canceled for note #{id}")
    end
  end
end
