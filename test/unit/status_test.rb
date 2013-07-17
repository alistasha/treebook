require 'test_helper'

# > ruby -Itest test/unit/status_test.rb

class StatusTest < ActiveSupport::TestCas e
	test "that a status requires content" do
		# We're going to create a new status there
		status = Status.new
		# we're going to assert that the status can't save
		assert !status.save
		# and make sure that we have an error on our content field.  
		assert !status.errors[:content].empty?
	end

	test "that a status's content is at least 2 letters" do
		status = Status.new
		# set the content to just the letter 'H'
		status.content = "H"
		assert !status.save
		assert !status.errors[:content].empty?
	end

	# Nobody can just post statuses without a user associated.
	test "that a status has a user id" do
		status = Status.new
		# We'll make sure we have the correct content
		status.content = "Hello"
		assert !status.save
		assert !status.errors[:user_id].empty?
	end
end
