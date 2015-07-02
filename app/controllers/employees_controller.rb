class EmployeesController < ApplicationController
   before_action { protect_controllers(9) } 
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  before_action :reporting_to, only: [:new, :edit, :update, :destroy]
  respond_to :html

#:first_name, :last_name, :employeecode, :designation, :mobile, :emailid,
# :location, :employment_type_id, :employee_role_id, :reporting_to_id, 
#:enablelogin, :description
  def index
     @showall = 'true'    
    if params.has_key?(:search)
      @search = "Search for " +  params[:search].upcase
      @searchvalue = params[:search].upcase   
      @employees = Employee.where("UPPER(first_name) like ? OR UPPER(last_name) like ? or 
        UPPER(employeecode) like ? or UPPER(description) like ?", "#{@searchvalue}%", 
        "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
      @found = @employees.count
     
     elsif params[:showall] == 'true'
        
      @search = "All Employees"
      @searchvalue = nil
      @employees = Employee.all.paginate(:page => params[:page])
      @found = @employees.count
    else
      @search = "Recently Added / Updated Employees"
      @searchvalue = nil
      @employees = Employee.order("updated_at DESC").limit(10).paginate(:page => params[:page])
      @found = @employees.count
    
    end

    # @employees = Employee.order("updated_at DESC").limit(10)
    # respond_with(@employees)
  end

  def show
    chkuser = User.where(employee_code: @employee.employeecode)

    if chkuser.present?
      @addnewlogin = true
      @userpas = chkuser.first
      @userstatus = "This employee #{chkuser.first.name} has already got a Login Id: #{chkuser.first.employee_code} and password, you may change the password here"
      respond_with(@employee, @userpas)
   else
     @addnewlogin = false
     @user = User.new(name: @employee.name, employee_code: @employee.employeecode, 
      email: @employee.emailid , role: @employee.employee_role_id)
      @userstatus = "This employee has does not have Login Id"
    
     respond_with(@employee, @user)
    end

  end

  def new
    @employeeroles = EmployeeRole.where('sortorder >= ?', current_user.employee_role.sortorder)
    @employee = Employee.new
    respond_with(@employee)
  end

  def edit
    @employeeroles = EmployeeRole.where('sortorder >= ?', current_user.employee_role.sortorder)
  
  end

  def create
    @employeeroles = EmployeeRole.where('sortorder >= ?', current_user.employee_role.sortorder)
    @employee = Employee.new(employee_params)
    @employee.save
    respond_with(@employee)
  end

  def update
   @userroles = EmployeeRole.where('sortorder >= ?', current_user.employee_role.sortorder)
   employeecode = @employee.employeecode
    @employee.update(employee_params)
     chkuser = User.where(employee_code: employeecode)

     if user = User.where(employee_code: employeecode).present?
      users = User.where(employee_code: employee_params[:employeecode])
        if users.present?
            users.each do |u|
            u.update(employee_code: employeecode)
            end
        end
     end

    
     if chkuser.present?
      chkuser.first.update(role: @employee.employee_role_id)
     end

    respond_with(@employee)
  end

  def destroy
    #check if the username exists for the same employee
    if user = User.find(employee_code: @employee.employeecode).present?
      users = User.find(employee_code: @employee.employeecode)

      users.each do |u|
        u.destroy
      end
    end
    @employee.destroy
    
    respond_with(@employee)
  end

  private
  def reporting_to
    @reporting = Employee.all.order("first_name").joins(:employee_role).where("employee_roles.sortorder < 9")
  end
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:title, :first_name, :last_name, :employeecode, :designation, :mobile, :emailid, :location, :employment_type_id, :employee_role_id, :reporting_to_id, :enablelogin, :description)
    end
end
