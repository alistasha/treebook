require 'test_helper'

class UserTest < ActiveSupport::TestCase
	# Since a user can have more than 1 friend, we're going to use a has_many association. 
	should have_many(:user_friendships)
	should have_many(:friends)

	# a user actually didn't enter their first name ?
	test "a user should enter a first name" do
		user = User.new		# we're creating a new user variable by saying user is a new instance of the User class.
		assert !user.save	# what that should do is tell us that the user should not be saved in our database.
		assert !user.errors[:first_name].empty?	# the errors on the first name field are not empty.
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:jason).profile_name

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	# For user's profile name correctness
	test "a user should have a profile name without spaces" do
		user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
		user.password = user.password_confirmation = 'asdfasdf'
		
		user.profile_name = "My Profile With Spaces"

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?("Must be formatted correctly.")	# to make sure we're getting the correct error message.
		# We'll do this by checking the errors array with the profile name key.
	end

	test "a user can have correctly formatted profile name" do
		user = User.new(first_name: 'Jason', last_name: 'Seifer', email: 'jason2@teamtreehouse.com')
		user.password = user.password_confirmation = 'asdfasdf'

		user.profile_name = 'jasonseifer_1'
		assert user.valid?
	end

	test "that no error is raised when trying to access a friend list" do
		assert_nothing_raised do
			users(:jason).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:jason).friends << users(:mike)
		users(:jason).friends.reload
		assert users(:jason).friends.include?(users(:mike))
	end

	test "that calling to_param on a user returns the profile_name" do
		assert_equal "jasonseifer", users(:jason).to_param
	end
end
