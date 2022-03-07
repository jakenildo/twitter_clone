class User < ApplicationRecord
  attr_accessor :remember_token

  # Followed Users
  has_many :active_relationships, foreign_key: "follower_id",
                                  class_name: "Relationship",
                                  dependent: :destroy

  has_many :followed_users, through: :active_relationships, source: :followed    

  # Followers
  has_many :passive_relationships, foreign_key: "followed_id",
                                  class_name: "Relationship",
                                  dependent: :destroy
                                  
  has_many :followers, through: :passive_relationships, source: :follower    

  # Relationship Link between the microposts and the Users
  has_many :microposts, dependent: :destroy

  #Model will check if name is Present, Minimum Characters of 5
  validates :name, presence: true, length: { minimum: 3 }
   
  # User email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # User password
  has_secure_password #only works if it has bcrypt

  validates :password, presence: true, length: { minimum: 7}

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def digest
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of the given string.
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Forgets a user.
  def forget_token
    update_attribute(:remember_digest, nil)
  end

  # Remembers a user.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end
    
  # returns true if the current user is following the other user
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  # Follows a user
  def follow(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end

  # Unfollow a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

end
