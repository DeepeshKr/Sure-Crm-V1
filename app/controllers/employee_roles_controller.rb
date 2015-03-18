class EmployeeRolesController < ApplicationController
  before_action :set_employee_role, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @employee_roles = EmployeeRole.all.order("sortorder")
    respond_with(@employee_roles)
  end

  def show
    respond_with(@employee_role)
  end

  def new
    @employee_role = EmployeeRole.new
    respond_with(@employee_role)
  end

  def edit
  end

  def create
    @employee_role = EmployeeRole.new(employee_role_params)
    @employee_role.save
    respond_with(@employee_role)
  end

  def update
    @employee_role.update(employee_role_params)
    respond_with(@employee_role)
  end

  def destroy
    @employee_role.destroy
    respond_with(@employee_role)
  end

  private
    def set_employee_role
      @employee_role = EmployeeRole.find(params[:id])
    end

    def employee_role_params
      params.require(:employee_role).permit(:name, :sortorder)
    end
end
