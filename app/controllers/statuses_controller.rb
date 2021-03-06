class StatusesController < ApplicationController
  # Before filters will run before anything else in the controller.
  # Devise will create some helpers to use inside your controllers and views
  # To setup a controller with user authentication, just add this before_filter:
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update]

  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])
    @comments = @status.comments.all

    if user_signed_in?
      @rating_currentuser = @status.ratings.find_by_user_id(current_user.id)
      unless @rating_currentuser 
        @rating_currentuser = current_user.ratings.new
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    # we know that we already have to be signed-in in order to post
    @status = current_user.statuses.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render json: @status, status: :created, location: @status }
      else
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    @status = current_user.statuses.find(params[:id])
    
    # Not only going to check if the status param has a key user_id,
    # but also that there's a status param
    if params[:status] && params[:status].has_key?(:user_id)
      # we delete the user_id param inside of the status params hash.
      params[:status].delete(:user_id)
    end

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
    end
  end
end
