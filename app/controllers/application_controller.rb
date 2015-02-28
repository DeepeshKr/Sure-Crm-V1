class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # after_filter :store_location

  # this for to create sessions 
  include SessionsHelper
  #"Before" filters may halt the request cycle. 
  #A common "before" filter is one which requires that a user is 
  #logged in for an action to be run
  before_action :require_login
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url # halts request cycle
      
    end
  end

  

  protected

def confirm_logged_in
    unless session[:id]
        flash[:notice] = "Please log in"
        redirect_to :root
        return false
    else
      after_sign_in_path_for(user)
        return true
    end
end


# If your model is called User
def after_sign_in_path_for(resource)
  session["user_return_to"] || root_path
end

# Or if you need to blacklist for some reason
def after_sign_in_path_for(resource)
  blacklist = [new_user_session_path, new_user_registration_path] # etc...
  last_url = session["user_return_to"]
  if blacklist.include?(last_url)
    root_path
  else
    last_url
  end
end
 
  
end
