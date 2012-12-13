class UserFriendship < ActiveRecord::Base
	belongs_to :user
	# The way that we tell Rails that we want a friend to be a user 
	# is by specifying something called the class name.
	belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'	# The foreign key is going to be the attribute in the database what we created.

	attr_accessible :user, :friend, :user_id, :friend_id
end
