class User < ActiveRecord::Base

 has_many :microposts, dependent: :destroy
 has_many :relationships, foreign_key: "follower_id", dependent: :destroy
 has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
 has_many :followed_users, through: :relationships, source: :followed
 has_many :followers, through: :reverse_relationships
 before_save { self.email= email.downcase }
 before_create :create_remember_token

 validates :name,  presence: true, length: { maximum: 50 }
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
 validates :email, presence: true, 
 format: { with: VALID_EMAIL_REGEX }, 
 uniqueness: { case_sensitive: false}

 has_secure_password
 validates :password, length: {minimum: 6}

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.not_read_destinated_to(self)
  end

  def conversation(other_user)
    Micropost.from_conversation_between(self, other_user)
  end

  def notes(other_user)
    Micropost.notes_between(self, other_user)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    if relationships.find_by(followed_id: other_user.id)
    elsif other_user.relationships.find_by(followed_id: self.id)
    else
      relationships.create!(followed_id: other_user.id)
    end
  end

  def relationship_with(other_user)
    if relationships.find_by(followed_id: other_user.id)
     relationships.find_by(followed_id: other_user.id)
   elsif other_user.relationships.find_by(followed_id: self.id)
     other_user.relationships.find_by(followed_id: self.id)
   else
   end
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

  def create_remember_token
   self.remember_token = User.encrypt(User.new_remember_token)
  end



end
