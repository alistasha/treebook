require 'test_helper'

# > ruby -Itest test/integration/custom_routes_test.rb

class CustomRoutesTest < ActionDispatch::IntegrationTest
	# make sure that we can just get login page through login route
	test "that /login route opens the login page" do
		# in order to test this, I can use the get command,
		# and then I give it the custom path that I want to go to, which is /login
		get '/login'
		# I want to asset that the response was successful.
		assert_response :success
	end
	# make sure that we can just get logout page through logout route
	test "that /logout route opens the logout page" do
		get '/logout'
		# We're going to assert that the response was a redirect		
		assert_response :redirect
		# and that we get redirected to the root path
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
