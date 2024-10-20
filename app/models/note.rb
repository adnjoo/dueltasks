class Note < ApplicationRecord
  scope :not_archived, -> { where(archived: false) }

  belongs_to :user

  validates :title, presence: true
  # content validation removed, allowing empty content
end
