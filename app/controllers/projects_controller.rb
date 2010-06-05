class ProjectsController < AuthenticatedController

  before_filter :admin_filter, :only => [:index, :add_user, :remove_user]
  before_filter :get_project_by_id, :only => [:destroy, :update, :show, :select_project, :edit]
  
  def index
    @projects = current_user.projects
  end
  
  def mytasks_tab
    render :partial => 'projects/mytasks', :layout => false
  end
  
  def kanban_tab
    render :partial => 'kanban/board', :layout => false
  end
  
  def backlog_tab
    render :partial => 'kanban/backlog', :layout => false
  end
  
  def new
    @project = Project.new
  end

  def create
    begin
      @project = current_user.projects.create(params[:project])
      @project.save!
      render :action => 'index'
    rescue Exception => e
      flash.now[:error]  = "Project creation failed - please try again. #{e}"
      flash.now[:error] << @project.errors.inspect
      @project = Project.new
      render :action => 'new'
    end
  end

  def update
    @project.update_attributes(params[:project])
    render :action => 'show'  
  end
      
  def destroy
    @project.destroy
    render :action => 'index'
  end
  
  def select_project
    render :action => 'show', :id => @project.id
  end
  
  def ajax_popup_card
    render :partial => 'projects/popup_card', :layout => false
  end

  def activity_log
    @entries = @project.activity_log_entries.paginate :page => params[:page], :order => 'created_at ASC'
  end

	def add_user
    @project = Project.find(params[:id])
    @user = User.find(params[:user_id])
    @user.projects << @project
    @user.save!
    redirect_to admin_user_path(@user)
	end
	
	def remove_user
	  @project = Project.find(params[:id])
    @user = User.find(params[:user_id])
    @user.disassociate_from_project(@project)
    @project.save!
    respond_to do |format|
      format.html { redirect_to admin_user_path(@user) }
      format.json { render :status => 200, :json => @user }
    end 
	end
  
  def invite_user
    email = params[:user][:email]
    if @user=User.find_by_email(email)
      @project.users << @user
      @user.save
    else
      password = generate_random_password
      @user = User.create!(:email => email, :login => email, :password => password, :password_confirmation => password )
      @project.users << @user
      @user.save!
      @user.deliver_project_invitation(@project, current_user) #if RAILS_ENV=='production'
    end
    render :json => @user, :success => true
  end
  
  protected
    def get_project_by_id
      @project = @current_user.projects.find(params[:id])
    end
    
    def generate_random_password
      (0...20).map{ ('a'..'z').to_a[rand(26)] }.join
    end
    
end
