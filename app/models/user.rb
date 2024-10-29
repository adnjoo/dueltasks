class User < ApplicationRecord
  after_create :send_welcome_email
  has_one_attached :profile_image

  has_many :notes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }, allow_nil: true

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

  def profile_picture
    profile_image.attached? ? profile_image : ActionController::Base.helpers.asset_path("default-avatar.png")
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
