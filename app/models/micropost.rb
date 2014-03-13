class Micropost < ActiveRecord::Base
	belongs_to :user
	default_scope -> {order('created_at DESC')}
	validates :user_id, presence: true
	validates :content, presence: true
	#, length: {maximum: 200}	
	validates :recipient_id, presence: true	

	
	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
		WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
			user_id: user.id)
	end

	def self.from_conversation_between(user1, user2)

		where("((recipient_id = :user2_id AND user_id = :user1_id)
			OR (recipient_id = :user1_id AND user_id = :user2_id)) AND is_note = :false",
			user1_id: user1.id, user2_id: user2.id, false: false)
	end

	def self.notes_between(user1, user2)
			where("((recipient_id = :user2_id AND user_id = :user1_id)
			OR (recipient_id = :user1_id AND user_id = :user2_id)) AND is_note = :true",
			user1_id: user1.id, user2_id: user2.id, true: true)
	end

	def has_been_read
		self.new= false
	end


end
