class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Stripe
  validates :stripe_id, presence: true, uniqueness: true

  before_validation :create_stripe_reference, on: :create

  def create_stripe_reference
    response = Stripe::Customer.create(email: email)
    self.stripe_id = response.id
  end

  def retrieve_stripe_reference
    Stripe::Customer.retrieve(stripe_id)
  end
end
