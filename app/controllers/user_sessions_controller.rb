class UserSessionsController < ApplicationController
  skip_before_filter :store_location
  before_filter :keep_location

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]

  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @user_session }
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])

    respond_to do |format|
      format.html {
        if @user_session.save
          user = User.find_by_username(params[:user_session][:username])
          flash.keep[:notice] = "Successfully logged in."
          redirect_to user_path(user.id)
        else
          render :action => :new
        end
      }
      format.xml { render :xml => @user_session.to_xml }
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash.notice = "Successfully logged out."
    redirect_to root_path
  end
end
