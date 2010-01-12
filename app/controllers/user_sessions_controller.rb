class UserSessionsController < ApplicationController
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    redirect_to :controller => 'welcome', :action => 'index'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to :controller => 'projects', :action => 'index'
    else
      logger.error @user_session.errors.inspect
      flash[:error] = "Invalid Login Attempt - Please Try Again."
      redirect_back_or_default root_url
    end
  end
  
  def destroy
    current_user_session.destroy
    redirect_to root_url
  end
  
end
