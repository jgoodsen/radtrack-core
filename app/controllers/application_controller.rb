class ApplicationController < ActionController::Base

  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7b932ff465b8869b117bf9ebfee1dbcc'

  helper_method :current_user_session, :current_user

  protected
  
    def admin_filter
      current_user && current_user.admin?
    end
  
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must sign in to access this page"
        redirect_to root_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        redirect_back_or_default session[:return_to]
        return false
      end
    end

    def store_location
      session[:return_to] = request.env['REQUEST_URI'] unless request.xhr?
    end

  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
end
