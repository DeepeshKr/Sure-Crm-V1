class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # skip_before_action :require_login, only: [:new, :create]
  respond_to :html
  #before_filter :authenticate_user!
  def show
    
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
      # if @user.update(user_params)
       flash[:success] = 'You have sucessfully changed the user details!'
    else
      flash[:error] = 'You are not authorised to change the details!'
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
      #@roles = 
  end
  def user_params
      params.require(:user).permit(:name, :email, :employee_code, :password, :role, :password_confirmation)
  end
end
