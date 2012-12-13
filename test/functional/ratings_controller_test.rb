require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
# create 
  test "should not create rating anonymous" do
    assert_no_difference('Rating.count', 'Rating count has changed but should not') do
      post :create, :status_id => statuses(:three).id, :rating => { :user_id => users(:jim).id, :stars => 4 }
    end
    assert_redirected_to new_user_session_path
  end  
  test "should create rating signed in" do
    sign_in users(:jim)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :status_id => statuses(:three).id, :rating => { :user_id => users(:jim).id, :stars => 4 }
    end
    assert_redirected_to status_path(assigns(:status))
    assert_equal 'Thank you for rating this status!', flash[:notice]
  end
  test "should not create rating not assigned to status" do
    sign_in users(:jim)
    assert_raises(ActiveRecord::RecordNotFound) do
      assert_no_difference('Rating.count', "Rating count has changed but should not") do
        post :create, :status_id => 100, :rating => { :user_id => users(:jim).id, :stars => 4 }
      end  
    end
  end
  test "should not create rating not assigned to other user" do
    sign_in users(:jim)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :status_id => statuses(:three).id, :rating => { :user_id => users(:jason).id, :stars => 4 }
    end
    assert assigns(:rating).user_id == users(:jim).id, "Raing does not belong to the current user"   
  end    
  test "should not assign rating to other status" do
    sign_in users(:jim)
    assert_difference('Rating.count', 1, 'Rating count has not changed') do
      post :create, :status_id => statuses(:three).id, :rating => { :status_id => statuses(:one).id, :user_id => users(:jim).id, :stars => 4 }
    end
    assert_redirected_to status_path(assigns(:status))
    assert_equal 'Thank you for rating this status!', flash[:notice]
    assert assigns(:rating).status_id ==  statuses(:three).id, "Rating does not belong to the right status"   
  end
  # update
   test "should not update rating anonymous" do  
     put :update, :status_id => statuses(:three).id, :id => ratings(:two).id, :rating => { :user_id => users(:jim).id, :stars => 2 }
     assert_redirected_to new_user_session_path
   end
   test "should not update rating linked to other user" do
     sign_in users(:jim)
     assert_raises(ActiveRecord::RecordNotFound) do
       put :update, :status_id => statuses(:one).id, :id => ratings(:one).id, :rating => { :user_id => users(:jason).id, :stars => 2 }
     end
   end  
  
  # delete
  test "should not destroy rating anonymous" do
     assert_no_difference('Rating.count') do
       delete :destroy, :status_id => ratings(:two).status_id, :id => ratings(:two).id
     end
     assert_redirected_to new_user_session_path
   end
   test "should not destroy rating linked to other user" do
     sign_in users(:jim)
     assert_raises(ActiveRecord::RecordNotFound) do
       assert_no_difference('Rating.count', "Rating count has changed but should not") do
         delete :destroy, :user_id => users(:jason).id, :status_id => ratings(:one).status_id, :id => ratings(:one).id
       end  
     end
   end
end
