class User < ApplicationRecord
  after_create :send_welcome_email

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

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
