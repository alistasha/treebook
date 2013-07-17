require 'test_helper'

# > ruby -Itest test/functional/profiles_controller_test.rb

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    # We want to send in the person's profile name.
    # We're going to do that by using an ID key since Rails generates that for us automatically.

    # Now remember, inside of our test fixtures, we have one user set up, and that's jason
    # I can tell Rails in this test that when I get the show action to send in my profile name.
    get :show, id: users(:jason).profile_name
    assert_response :success
    # We send in the template name
    # That's going to be the show template inside of the profiles directory in our views directory.
    assert_template 'profiles/show'
  end

  # If somebody's profile name isn't found
  # HTTP status code for "Not Found"
  test "should render a 404 on profile not found" do
  	get :show, id: "doesn't exist"
    # This test will make sure that the response is not found
    # if we send in a profile name that doesn't exist
  	assert_response :not_found
  end

  # we correctly assign variables when we get that show page. 
  test "that variables are assigned on successful profile viewing" do
  	get :show, id: users(:jason).profile_name
    # Contains instance variables from controllers in a controller test
    # Assigns will make sure that instance variables and controllers are properly set. 
  	assert assigns(:user)
    # making sure that an array contains at least 1 or more items, and then it's not empty. 
  	assert_not_empty assigns(:statuses)
  end

  # we'll make sure that only the correct statuses are shown on a user.
  test "only shows the correct user's statuses" do
  	get :show, id: users(:jason).profile_name
    # Since we already know that the statuses are being assigned, 
    # let's loop through them and make sure that the user of the status matches the correct user.
  	assigns(:statuses).each do |status|
  		assert_equal users(:jason), status.user   # make sure that the correct user matches the status user. 
  	end
  end

end
