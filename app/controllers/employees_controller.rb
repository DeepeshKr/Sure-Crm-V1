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
  
  def sales_team
    valid_employement_types = [10005,10006,10007,10000,10001,10002,10010] # trainee, probation etc
    valid_sales_roles = [10002,10021,10020,10161,10003,10081] # amanger team capatain etc
    @employees = Employee.where(employment_type_id: valid_employement_types, employee_role_id:valid_sales_roles)
    #show all sales team
    # 10002
    @managers = @employees.where(employee_role_id: 10002)
    @manager_list_name = "Managers"
    @no_of_managers = @managers.count
    # 10021
    @supervisors = @employees.where(employee_role_id: 10021)
    @supervisors_list_name = "Supervisor and Team coaches"
    @no_of_supervisors = @supervisors.count
    # 10020
    @captains = @employees.where(employee_role_id: 10020)
    @captains_list_name = "Sr Team Captains"
    @no_of_captains = @captains.count
    # 10161
    @sales_trainers = @employees.where(employee_role_id: 10161)
    @sales_trainers_list_name = "Sales Trainers"
    @no_of_sales_trainers = @sales_trainers.count
    # 10003
    @sales_executives = @employees.where(employee_role_id: 10003)
    @sales_executives_list_name = "Sales Executives"
    @no_of_sales_executives = @sales_executives.count
    # 10081
    @sales_trainees = @employees.where(employee_role_id: 10081)
    @sales_trainees_list_name = "Sales Trainees"
    @no_of_sales_trainees = @sales_trainees.count

    
  end

  def show
    chkuser = User.where(employee_code: @employee.employeecode)

    if chkuser.present?
      @addnewlogin = true
      @userpas = chkuser.first
      if @employee.name != chkuser.first.name
         @userstatus = "Resolve the conflict of employee #{chkuser.first.name} and #{@employee.name} and Login Id: #{chkuser.first.employee_code} and #{@employee.employeecode} when you update the password, click on changed password below to update the details, new details would be Name: #{@employee.name} and Employee Code: #{@employee.employeecode}"
      else
         @userstatus = "This employee #{chkuser.first.name} has already got a Login Id: #{chkuser.first.employee_code} and password, you may change the password here"
      end
     
    	 @employee_code = @employee.employeecode
    	 @employee_name = @employee.name
    	 @employee_role_id = @employee.employee_role_id
    	 @employee_emailid = @employee.emailid
        
      respond_with(@employee, @user)
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
