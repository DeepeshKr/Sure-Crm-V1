class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @employees = Employee.all
    respond_with(@employees)
  end

  def show
    chkuser = User.where(employee_code: @employee.employeecode)



    if chkuser.present?
      @addnewlogin = true
      @userpas = chkuser.first
      respond_with(@employee, @userpas)
   else
     @addnewlogin = false
     @user = User.new(name: @employee.name, employee_code: @employee.employeecode, 
      email: @employee.emailid , role: @employee.employee_role_id)
     respond_with(@employee, @user)
    end

  end

  def new
    @employee = Employee.new
    respond_with(@employee)
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.save
    respond_with(@employee)
  end

  def update
    @employee.update(employee_params)

     chkuser = User.where(employee_code: @employee.employeecode)
     if chkuser.present?
      chkuser.first.update(role: @employee.employee_role_id)
     end

    respond_with(@employee)
  end

  def destroy
    @employee.destroy
    respond_with(@employee)
  end

  private
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:title, :first_name, :last_name, :employeecode, :designation, :mobile, :emailid, :location, :employment_type_id, :employee_role_id, :reporting_to_id, :enablelogin, :description)
    end
end
