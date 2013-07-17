require 'test_helper'

# https://github.com/thoughtbot/shoulda-context 참조

class UserFriendshipsControllerTest < ActionController::TestCase
  # when I'm going to do a new friendship and I'm not logged in,
  # I want to be redirected to the login page
  # which is going to tell the application that i need to log in first.
  context "#new" do
  	context "when not logged in" do
  	  should "redirect to the login page" do
  	  	get :new
  	  	assert_response :redirect
  	  end	
  	end

    # when somebody is logged in.
  	context "when logged in" do
      # we can put some behavior that's going to occur
      # before each of our tests in a stup block
  	  setup do
  	  	sign_in users(:jason)
  	  end

      # let's just make sure that I successfully get the new page
  	  should "get new and return success" do
  	  	get :new
  	  	assert_response :success
  	  end

      # We want to make sure that somebody passes in a friend ID
      # when they go to create a new user friendship.

      # what we'll do is we'll set error messages inside of our flash hash
      # if somebody doesn't send in a friend ID.
  	  should "should set a flash error if the friend_id params is missing" do
  	  	get :new, {}  # sending no params
  	  	assert_equal "Friend required", flash[:error]
  	  end

  	  should "display the friend's name" do
        # get the new page only I'm sending in the friend ID
        # of an actual user in the system.
  	  	get :new, friend_id: users(:jim)
  	  	assert_match /#{users(:jim).full_name}/, response.body
  	  end

  	  should "assign a new user friendship" do        
  	  	get :new, friend_id: users(:jim)
  	  	assert assigns(:user_friendship)
  	  end

  	  should "assign a new user friendship to the correct friend" do
  	  	get :new, friend_id: users(:jim)
  	  	assert_equal users(:jim), assigns(:user_friendship).friend
  	  end

  	  should "assign a new user friendship to the currently logged in user" do
  	  	get :new, friend_id: users(:jim)
  	  	assert_equal users(:jason), assigns(:user_friendship).user
  	  end

  	  should "returns a 404 status if no friend is found" do
  		get :new, friend_id: 'invalid'
  		assert_response :not_found
  	  end

      should "ask if you really want to friend the user" do
        get :new, friend_id: users(:jim)
        assert_match /Do you really want to friend #{users(:jim).full_name}?/, response.body
      end
  	end
  end

  context "#create" do
    context "when not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:jason)
      end

      context "with no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to the site root" do
          assert_redirected_to root_path
        end
      end

      context "with a valid friend_id" do
        setup do
          post :create, user_friendship: {friend_id: users(:mike)}
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mike), assigns(:friend)
        end

        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:jason), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:jason).friends.include?(users(:mike))
        end

        should "redirect to the profile page of the friend" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mike))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:mike).full_name}", flash[:success]
        end
      end
    end
  end
end
