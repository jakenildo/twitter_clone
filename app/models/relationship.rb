class Relationship < ApplicationRecord
    # Since theres no  Followed nor Follower Model
    # We need to supply the class name under User

    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    validates :follower_id, presence: true
    validates :followed_id, presence: true
end
