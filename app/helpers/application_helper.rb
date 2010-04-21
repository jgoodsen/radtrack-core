# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  include ActionView::Helpers::UrlHelper
  
  ## TODO: I think we can remove all of the css_task_state stuff below...
  def css_task_state_for(task_state)
    task_state.name.downcase.gsub(' ', '_')
  end
  
  def css_task_states_for(project)
    project.task_states.collect{|x| " " + css_task_state_for(x)}.to_s.strip
  end
  
  def css_user_capacity_state(project, user)
    (project.kanban_tasks_for(user).select{|t| t.task_state.started?}.size >= 2) ? "team_member_status_maximum_capacity" : "team_member_status_has_capacity"
  end

  ## TODO: Remove this once we have user definable card types and associated images
  def card_type_image_icon_tag(card)
    def do_image_tag(type)
      content_tag :span, '', :class => "card_type_icon card_type_icon_#{type}"
    end
    def image_icon_tag(name)
      return case name
        when "Feature (MMF)" : do_image_tag('feature')
        when "User Story" : do_image_tag('card')
        when "Technical Debt" : do_image_tag('technical_debt')
        when "Defect" : do_image_tag('defect')
        when "Other" : do_image_tag('other')
        else ""
      end
    end
    image_icon_tag(card.card_state.name)
  end

  def display_flashes
    if flash[:notice]
      flash_to_display, level = flash[:notice], 'notice'
    elsif flash[:warning]
      flash_to_display, level = flash[:warning], 'warning'
    elsif flash[:error]
      flash_to_display, level = flash[:error], 'error'
    else
      return
    end
    content_tag 'div', flash_to_display, :class => "flash_#{level}"
  end
  
  def spinner
    image_tag 'spinner.gif', :style => "display: none;", :class => "spinner"
  end
  
  # Passes the authenticity token for use in javascript
  # See http://blog.lawrencepit.com/2008/09/04/unobtrusive-jquery-rails/
  def yield_authenticity_token
    if protect_against_forgery?
      <<JAVASCRIPT
  <script type='text/javascript'>
    //<![CDATA[
      window._auth_token_name = "#{request_forgery_protection_token}";
      window._auth_token = "#{form_authenticity_token}";
    //]]>
  </script>
JAVASCRIPT
    end
  end

  ## A handy utility to only expose features to beta users of the product.
  ## Edit the BETA_USERS constant in enironment.rb for now...
  def beta_user?(user = current_user)
    yield if ::BETA_USERS.include?(user.login)
  end
  
end
