class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> {order('created_at DESC')}
	validates :user_id, presence: true
	validates :content, presence: true, length: {maximum: 200}	
	validates :recipient_id, presence: true	
	
	def self.from_users_followed_by(user)
   followed_user_ids = "SELECT followed_id FROM relationships
   WHERE follower_id = :user_id"
   where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
     user_id: user.id)
 end

 def self.from_conversation_between(user1, user2)

            where("(recipient_id = :user2_id AND user_id = :user1_id)
            OR (recipient_id = :user1_id AND user_id = :user2_id)",
            user1_id: user1.id, user2_id: user2.id)
end


end
