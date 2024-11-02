class User < ApplicationRecord
  after_create :send_welcome_email
  has_one_attached :profile_picture

  attr_accessor :remove_profile_picture

  has_many :notes_users, dependent: :destroy
  has_many :notes, through: :notes_users

  # Direct association for notes the user owns
  has_many :owned_notes, class_name: "Note", foreign_key: :user_id, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }, allow_nil: true

  validate :profile_picture_size

  def subscribed?
    subscriptions.where(status: "active").any?
  end

  def self.leaderboard(limit = 10)
    self.left_joins(:notes)
      .group(:id)
      .order("COUNT(notes.id) DESC")
      .select("users.id, users.username, COUNT(notes.id) AS score")
      .where("notes.archived = true AND notes.completed = true")
      .where(public: true)
      .limit(limit)
  end

  def display_profile_picture
    profile_picture.attached? ? profile_picture : ActionController::Base.helpers.asset_path("default-avatar.png")
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def profile_picture_size
    if profile_picture.attached? && profile_picture.blob.byte_size > 500.kilobytes
      errors.add(:profile_picture, "must be less than 500KB")
    end
  end
end
