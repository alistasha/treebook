class ProfilesController < ApplicationController
  def show
  	# We're going to set that user when we find it to an instance variable called "user"
  	# Instance variables, when set in a controller are available to our views as well.
  	@user = User.find_by_profile_name(params[:id])	# look at the database and find me a user by profile name
  	if @user
  		# Find only this user's statuses
  		# Since we have a relationship between users and statuses,
  		# we can just say, to get all of the user statuses instead of all of the different statuses.
  		@statuses = @user.statuses.all
  		# then we can actually render our template, which is the show template in the profiles directory.
  		# All we have to do for that is say to render the action show.
  		render action: :show
  	else
  		# We'll just have Rails tell us to render this file and the status is 404, which means "Not Found"
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end
end
