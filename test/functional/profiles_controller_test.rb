require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show, id: users(:jason).profile_name
    assert_response :success
    assert_template 'profiles/show'
  end

  # HTTP status code for "Not Found"
  test "should render a 404 on profile not found" do
  	get :show, id: "doesn't exist"
  	assert_response :not_found
  end

  # we correctly assign variables when we get that show page. 
  test "that variables are assigned on successful profile viewing" do
  	get :show, id: users(:jason).profile_name
  	assert assigns(:user)  #Contains instance variables from controllers in a controller test
    # Assigns will make sure that instance variables and controllers are properly set. 
  	assert_not_empty assigns(:statuses)  # making sure that an array contains at least 1 or more items, and then it's not empty. 
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
