class UsersController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # skip_before_action :require_login, only: [:new, :create]
  respond_to :html
  #before_filter :authenticate_user!
  def show
    @empcode = current_user.employee_code
    employee_id = @employee.id
    chkuser = User.where(employee_code: @empcode)
    @user = chkuser.first
    @userpas = chkuser.first
    @userstatus = "This employee #{chkuser.first.name} has already got a Login Id: #{chkuser.first.employee_code} and password, you may change the password here"
   
    @user = User.find(params[:id])
    @userroles = EmployeeRole.where('sortorder >= ?', current_user.employee_role.sortorder)
     #debugger
  end
  
  def index
    @users = User.all
    respond_with(@users)
  end
  
  def new
      @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save 
      
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
         
  end
  def update   
    if current_user.employee_role.sortorder < 8
      
      @user.update(user_params) 
        # Parameters: {"utf8"=>"✓", "authenticity_token"=>"kuaEO5B6ZH/+HSrPD7OVpwelc/XRaLzUC/Dk7eknOOhPlMIdAUI2Qzd3DYSjK/OuaB/jR6MfbAnCqlSXU0+0Jw==", "user"=>{"id"=>"10591", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "employee_code"=>"426", "name"=>"biplap_sm  ", "role"=>"10003", "email"=>"", "commit"=>"Change Password", "id"=>"10591"}
        #
      @user.update(employee_code: params[:employee_code],
      name: params[:name], email: params[:email], role: params[:role])   
      # if @user.update(user_params)
       flash[:success] = 'You have sucessfully changed the user details!'
    else
      flash[:error] = 'You are not authorised to change the details!'
    end
    
    if params[:return_to].present?
      redirect_to params[:return_to] and return
    end
      respond_with(@user)
  end

    #else
      #respond_with(@product_variant)
   # end
   # respond_with(@product_variant.product_master)
   # def role_enum
   #    [:user, :manager, :accounts, :admin]
   #  end
  def destroy
    @user.destroy
    respond_with(@user)
  end

  private 
  def set_user
      @user = User.find(params[:id])
      @employee = Employee.find_by_employeecode(@user.employee_code)
      #@roles = 
  end
  def user_params
      params.require(:user).permit(:name, :email, :employee_code, :password, :role, :password_confirmation)
  end
end
