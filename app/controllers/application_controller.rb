class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
 
  # before_filter => to prevent back button from browser
  before_filter :store_location
  before_filter :set_cache_buster
  #before_filter :authenticate_user!
  # before_filter :authenticate_user!
  #after_filter :store_location
  # "Before" filters may halt the request cycle. 
  # A common "before" filter is one which requires that a user is logged in for an action to be run
  #before_action :store_location
  before_action :require_login

 def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # after_filter :store_location


  # this for to create sessions 
  include SessionsHelper
 
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url(return_to: request.original_url) # halts request cycle  
    end
  end

# def store_location
#   # store last url as long as it isn't a /users path
#   session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
# end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
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

  def protect_controllers(authorised_for)
    if logged_in?
      currentrolsortno = current_user.employee_role.sortorder || 20
      userrole = current_user.employee_role.name
      if current_user.employee_role.sortorder.to_i >= authorised_for.to_i
        #   flash[:notice] = "Authorised to view as #{userrole}"
        # else
        flash[:notice] = "Not Authorised to view as #{userrole}"
        redirect_to login_url(return_to: request.original_url) # halts request cycle  
      end
    end
  end

  def protect_controllers_specific(authorised_for)
    if logged_in?
      currentrolsortno = current_user.employee_role.sortorder || 20
      userrole = current_user.employee_role.name
      if currentrolsortno.to_i != authorised_for.to_i #|| current_user.employee_role.sortorder.to_i > 3
        #  
        flash[:notice] = "Not Authorised to view as #{userrole}"
        return redirect_to login_url(return_to: request.original_url) # halts request cycle  
       # else
       #  flash[:notice] = "Authorised to view as #{userrole}"
      end
      # if currentrolsortno.to_i > 3
      #       flash[:notice] = "Not Authorised to view as #{userrole}"
      #   return redirect_to login_url(return_to: request.original_url) # halts request cycle  
     
      # end
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

end
