class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new
  end
  
  def create
     user = User.find_by(employee_code: params[:session][:employee_code].downcase)
    if user && user.authenticate(params[:session][:password])
 # Log the user in and redirect to the user's show page.
 #also create a session for the user
 
     
     @insession = Sessions.find_by(sessionid: request.session_options[:id])
     if @insession.blank?
      @session = Sessions.new(session_params)
      @current_user ||= User.find_by(id: session[:user_id])
      @session[:userip] = request.env['REMOTE_ADDR']
      @session[:sessionid] = request.session_options[:id]
      @session.save
     else
       #@insession.update
       @insession.save
     end
    
    
    
     flash[:success] = 'You have sucessfully logged in!'
     
      log_in user
      #redirect_to user
      #redirect_to :back
      redirect_to after_sign_in_path_for(user)
    else
      # Create an error message.
       flash.now[:danger] = 'Invalid employee code password combination'
       # add more authentication details like employee name here
        render 'new'
    end
    
    
  end

  def destroy
    log_out
    redirect_to root_url
  end
  
   # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  
  private
    def session_params
      params.require(:session).permit(:employee_code, :emailid, :userip, :sessionid)
    end

    # If your model is called User
def after_sign_in_path_for(resource)
  session["user_return_to"] || root_path
end

# Or if you need to blacklist for some reason
# def after_sign_in_path_for(resource)
#   blacklist = [new_user_session_path, new_user_registration_path] # etc...
#   last_url = session["user_return_to"]
#   if blacklist.include?(last_url)
#     root_path
#   else
#     last_url
#   end
# end
end
