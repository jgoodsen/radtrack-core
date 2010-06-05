class AdminController < AuthenticatedController

  before_filter  :admin_filter, :except => [:ajax_error_monitor]

  def index
    redirect_to :controller => 'admin/users', :action => :index
  end
  
  def admin_filter
    unless current_user && current_user.admin?
      flash[:error] = "You don't have administrator priviliges"
      redirect_back_or_default root_url
    end
  end
  
  ## This method is a hook for the client to report ajax errors back to the server, so we can identify and diagnose user ajax errors
  def ajax_error_monitor
  
  end
  
end
