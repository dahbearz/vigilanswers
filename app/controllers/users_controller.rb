class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  #User Profile
  def index
    @user = current_user

    respond_to do |format|
      format.html
      format.xml { render :xml => @user.to_xml }
    end
  end

  def show
    @user = current_user

    respond_to do |format|
      format.html
      format.xml { render :xml => @user.xml}
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to user_path
    else
      render :action => :edit
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.address = "Atlanta, GA"
    if(@user.save)
      flash[:notice] = "Account registered!"
      redirect_to(root_path)
    else
      render(:action => :new)
    end
  end

  def destroy

  end

end
