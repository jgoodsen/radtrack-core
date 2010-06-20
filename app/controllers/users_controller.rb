class UsersController < AuthenticatedController
  
  before_filter :require_user, :except => [:new, :create]
  before_filter :require_user_edit_access, :except => [:show]
  
  def index
    if @project
      respond_to do |format|     
        format.json { 
          @users = @project.users
          render :status => 200, :json => @users 
        }
      end
    else
      redirect_to root_url
    end
  end
  
  def new
    @user ||= User.new
  end
  
  def create
    unless params[:invitation_code] == 'xhr798'
      flash[:notice] = "Invalid Invitation Code."
      @user = User.new
      render :action => :new
    else
      @user = User.new(params[:user])
      @user.login = @user.email
      if @user.save
        flash[:notice] = "Registration successful."
        redirect_to root_url
      else
        render :action => :new
      end
    end
  end
    
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to edit_user_url(current_user)
    else
      flash[:error] = nil
      render :action => :edit
    end
  end
  
  def show
    redirect_to root_url
  end
  
  private
  
    def require_user_edit_access
      @user = current_user if params[:id] == "current"
      @user ||= User.find_by_id(params[:id])
      unless @user == current_user || current_user.admin?
        flash[:error] = "#{current_user.login} does not have the privileges to edit #{@user.login}"
        redirect_to root_url
      end 
    end
    
end
