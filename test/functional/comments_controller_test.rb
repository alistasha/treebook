require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
	# create
	test "should not create comment anonymous" do
		assert_no_difference('Comment.count', 'Comment count has changed but should not') do
		  post :create, :status_id => statuses(:three).id, :comment => { :user_id => users(:jim).id, :body => 'Comment' }
		end
		assert_redirected_to new_user_session_path
	end
	test "should create comment signed in" do
		sign_in users(:jim)
		assert_difference('Comment.count', 1, 'Comment count has not changed') do
		  post :create, :status_id => statuses(:three).id, :comment => { :user_id => users(:jim).id, :body => 'Comment' }
		end
		assert_redirected_to status_path(assigns(:status))
		assert_equal 'Comment was successfully created.', flash[:notice]
	end
	test "should not create comment not assigned to status" do
		sign_in users(:jim)
		assert_raises(ActiveRecord::RecordNotFound) do
			assert_no_difference('Comment.count', "Comment count has changed but should not") do
				post :create, :status_id => 100, :comment => { :user_id => users(:jim).id, :body => 'Comment' }
			end  
		end
	end
	test "should not create comment not assigned to other user" do
		sign_in users(:jim)
		assert_difference('Comment.count', 1, 'Comment count has not changed') do
			post :create, :status_id => statuses(:three).id, :comment => { :user_id => users(:jim).id, :body => 'Comment' }
		end
		assert assigns(:comment).user_id == users(:jim).id, "Comment does not belong to the current user"   
	end    
	test "should not assign comment to other status" do
		sign_in users(:jim)
		assert_difference('Comment.count', 1, 'Comment count has not changed') do
			post :create, :status_id => statuses(:three).id, :comment => { :status_id => statuses(:two).id, :user_id => users(:jim).id, :body => 'Comment' }
		end
		assert_redirected_to status_path(assigns(:status))
		assert_equal 'Comment was successfully created.', flash[:notice]
		assert assigns(:comment).status_id ==  statuses(:three).id, "Comment does not belong to the right status"   
	end

	# destroy
	test "should not destroy comment anonymous" do
		assert_no_difference('Comment.count') do
			delete :destroy, :status_id => comments(:one).status_id, :id => comments(:one).id
		end
	assert_redirected_to new_user_session_path
	end
	test "should not destroy comment linked to other user" do
		sign_in users(:jim)
		assert_raises(ActiveRecord::RecordNotFound) do
			assert_no_difference('Comment.count', "Comment count has changed but should not") do
				delete :destroy, :user_id => users(:jason).id, :status_id => comments(:one).id, :id => comments(:one).id
			end  
		end
	end  
end
