class TasksController < AuthenticatedController
  
  def create
    @task = @card.tasks.create! params[:task]
    respond_to do |format|
      format.html {
        raise "HTML task creation is not allowed, AJAX only."
      }
      format.js
    end
  end
  
  def destroy
    task = @card.tasks.find(params[:id])
    task.destroy
    respond_to do |format|
      format.html {
        raise "HTML task deletion is not allowed, AJAX only."
      }
      format.js {
        render :status => 200, :json => "{\"taskid\":\"task_#{task.id}\"}"
      }
    end
  end
    
  def update
    task = @card.tasks.find(params[:id])
    task.update_attributes(params[:task])
    render :status => 200, :json => task_as_json(task)
  end

  def next_state
    task = @card.tasks.find(params[:task_id])
    task.next_state
    task.save!
    redirect_to request.env['HTTP_REFERER']
  end
  
  def previous_state
    task = @card.tasks.find(params[:task_id])
    task.previous_state
    task.save!
    redirect_to request.env['HTTP_REFERER']
  end
  
  def grabit
    task = @card.tasks.find(params[:task_id])
    task.user = current_user
    task.save!
    redirect_to request.env['HTTP_REFERER']
  end
  
  ## Used to capture field level edits from the jquery inlineEditor
  def update_attribute
    task = @card.tasks.find(params[:task_id])
    task.update_attributes({params[:attribute] => params[:update_value]})
    render :text => task.send(params[:attribute])
  end
  
  private
  
    def task_as_json(task)
      task.attributes.merge(:task_state => task.task_state.name)
      task.to_json(:only => [:id, :name], :include => {:card, {:only => [:id]}})
    end
    
end
