class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
  # before_filter => to prevent back button from browser
  before_filter :store_location
  before_filter :set_cache_buster
 
 #after_filter :store_location

 def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

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

def store_location
  # store last url as long as it isn't a /users path
  session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
end

def after_update_path_for(resource)
  session[:previous_url] || root_path
end
 
def after_sign_in_path_for(resource)
  request.env['omniauth.origin'] || stored_location_for(resource) || root_url
end

def after_sign_in_path_for(resource)
  session[:previous_url] || root_path
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

end
