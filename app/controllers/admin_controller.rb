class AdminController < AuthenticatedController

  before_filter  :admin_filter

  def index
    redirect_to :controller => 'admin/users', :action => :index
  end
  
  def admin_filter
    unless current_user && current_user.admin?
      flash[:error] = "You don't have administrator privileges"
      redirect_back_or_default root_url
    end
  end

  def test
    render :view => 'test', :layout => false
  end
  
end
