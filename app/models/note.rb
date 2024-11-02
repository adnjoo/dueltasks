class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :notes_users, dependent: :destroy
  has_many :users, through: :notes_users

  after_save :schedule_penalty_check

  validates :title, presence: true

  # Helper methods to add and remove collaborators
  def add_collaborator(user)
    notes_users.find_or_create_by(user_id: user.id)
  end

  def remove_collaborator(user)
    users.delete(user)
  end

  def collaborators
    users.where.not(id: owner.id)
  end

  # Method to update collaborators by adding new ones and removing those not in the provided list (excluding owner)
  def update_collaborators(user_ids)
    current_user_ids = users.pluck(:id)
    new_user_ids = user_ids - current_user_ids
    removed_user_ids = current_user_ids - user_ids - [ owner.id ]

    new_users = User.where(id: new_user_ids)
    removed_users = User.where(id: removed_user_ids)

    new_users.each { |user| add_collaborator(user) }
    removed_users.each { |user| remove_collaborator(user) }

    Rails.logger.info("Added collaborators: #{new_user_ids}, Removed collaborators: #{removed_user_ids}")
  end

  def schedule_penalty_check
    if archived || !penalty_enabled
      cancel_penalty_job # Cancel the job if the note is archived or penalty is disabled
    elsif penalty_enabled
      if deadline.present?
        # Cancel any existing job
        cancel_penalty_job

        # Schedule a new job and save its ID
        job_id = PenaltyJob.perform_at(deadline + 1.minute, id)
        update_column(:penalty_job_id, job_id)

        puts("Scheduled penalty check for note #{id}")
      else
        puts("No deadline set for note #{id}, skipping penalty check scheduling.")
      end
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
