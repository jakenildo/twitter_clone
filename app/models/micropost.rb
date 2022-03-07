class Micropost < ApplicationRecord
  belongs_to :user

  default_scope -> { order('created_at DESC') }

  validates :content, presence: true, length: { maximum: 280 }

  validates :user_id, presence: true

  has_many :likes, dependent: :destroy

  has_one_attached :image

  validates :image , content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                                    size: { less_than: 5.megabytes,
                                    message: "should be less than 5MB" }

end
