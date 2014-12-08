class SessionsController < ApplicationController
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
      redirect_to user

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
    
  private
    def session_params
      params.require(:session).permit(:employee_code, :emailid, :userip, :sessionid)
    end
end
