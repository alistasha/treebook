require 'test_helper'

# > ruby -Itest test/functional/statuses_controller_test.rb

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect   # Which means it's going to re direct us to the log-in page, and 
    assert_redirected_to new_user_session_path  # we could even add in another assertion saying 'assert redirected to.'
  end

  # We're going to say sign in the jason user.
  # Then we're going to get the new page and make sure that was successful.
  test "should render the new page when logged in" do
    sign_in users(:jason)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello" }  # We're posting to the create method with our status of "Hello"
    # make user we're redirected to the new user session path.
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status for the current user when logged in" do
    sign_in users(:jason)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:jim).id }
    end

    assert_redirected_to status_path(assigns(:status))
    # We'll also assert that the statuses user_id is the same as Jason's user_id from our fixture.
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should create status when logged in" do
    # we'll do the same thing where we sign in a user before running the status-creation code.
    sign_in users(:jason)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:jason)
    get :edit, id: @status
    assert_response :success
  end

  test "should update status when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status for the current user when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content, user_id: users(:jim).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should not update the status if nothing has changed" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content, user_id: users(:jim).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
