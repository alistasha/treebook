require 'test_helper'


# make sure that a user friendship belongs to both the user and a friend.
class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)

	test "that creating a friendship works without raising an exception" do
		# As the name implies, assert_nothing_raised will make sure that no errors 
		# or exceptions pop up inside of this block of code here.
		assert_nothing_raised do
			UserFriendship.create user: users(:jason), friend: users(:mike)	
		end
	end

	test "that creating a friendships based on user id and friend id works" do
		UserFriendship.create user_id: users(:jason).id, friend_id: users(:mike).id
		assert users(:jason).friends.include?(users(:mike))
	end
end
