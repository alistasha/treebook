require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
	# make sure that we can just get login page through login route
	test "that /login route opens the login page" do
		get '/login'
		assert_response :success
	end
	# make sure that we can just get logout page through logout route
	test "that /logout route opens the logout page" do
		get '/logout'
		assert_response :redirect
		assert_redirected_to '/'
	end
	# make sure that we can just get sign up page through register route
	test "that /register route opens the sign up page" do
		get '/register'
		assert_response :success
	end
	# make sure that we can just get a person's profile page
	test "that a profile page works" do
		get '/jasonseifer'
		assert_response :success
	end
end
