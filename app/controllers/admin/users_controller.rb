class Admin::UsersController < AdminController
  
  USER_CREATED_MESSAGE = 'User was created.'
  USER_CREATION_FAILED_MESSAGE = 'User creation failed.'

  # render new.rhtml
  def new
    @user = User.new
  end

  def index
    @users = User.all.paginate :page => params[:page], :order => 'login DESC'
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy if @user
    redirect_to admin_users_url
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "User created."
      redirect_to :controller => 'admin/users', :action => :index
    else
      render :action => :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
end
