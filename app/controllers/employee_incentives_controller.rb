class EmployeeIncentivesController < ApplicationController
  before_action { protect_controllers(6) }
  respond_to :html
  def index
    @show_results = "true"
    @sales_agents = Employee.all.where(:employee_role_id => 10003).order("first_name")
    @employee_name = "Set Dates for "
    use_from_to_date 30
    if @from_date == nil
      return
    end
    @empcode = current_user.employee_code
    @logged_employee_id = Employee.where(employeecode: @empcode).first.id
    if (current_user.id != 10871 && current_user.id != 10100 && current_user.id != 10000)
      flash[:success] = "The reports are not showing there seems to be an error #{@logged_employee_id} user id #{current_user.id} !"
      return
    end

    @data_warn = "Show Report, name: nil, class: btn btn-primary"
    @emp_order = current_user.employee_role.sortorder
    @show_for = params[:show_for]
    flash[:success] = "Working #{@show_for} report from #{@from_date} to #{@to_date}"
    if @show_for == "Employee"
      @employee_id = params[:employee_id]
      if @employee_id.blank?
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        flash[:error] = "Please select the employee to view the details"
        return
      end
        @employee = Employee.find(@employee_id)
        @employee_name = @employee.fullname
        @employeecode = @employee.employeecode
        employee_sale = EmployeeSales.new
        @employee_sales = employee_sale.sales_data @from_date, @to_date, @employee_id

        #employeecode
        @sale_vpp =  VPP.where("basic > 0 and operator = ? and paiddate >= ? and paiddate <= ? and cfo is null and custref IS NOT NULL", @employeecode, @from_date, @to_date).order(:custref)
        @total_sales_value = @sale_vpp.sum(:basic)
        @total_sales_nos = @sale_vpp.count

        @refund_vpp =  VPP.where("operator = ? and refunddate >= ? and refunddate <= ? and cfo is null and custref IS NOT NULL", @employeecode, @from_date, @to_date).order(:custref)

        @total_refunds_value = @refund_vpp.sum(:basic)
        @total_refunds_nos = @refund_vpp.count

        @deal_trans = DEALTRAN.where("status = ? and operator = ? and statusdate >= ? and statusdate <= ?","D", @employeecode, @from_date, @to_date).order(:custref)

        @total_transfer_value = @deal_trans.sum(:basicprice)
        @total_transfer_nos = @deal_trans.count
        ######
        #####
        #####
        @order_sales = OrderMaster.where('paid_date >= ? AND paid_date <= ?', @from_date, @to_date)
        .where(employee_id: @employee_id).where.not(order_status_master_id: 10041).order(:external_order_no)

        @total_sales_value_s =   @order_sales.sum(:subtotal)
        @total_sales_nos_s =   @order_sales.sum(:pieces)
        #order_status_master_id, 10041

        @order_transfer = OrderMaster.where('paid_date >= ? AND paid_date <= ?', @from_date, @to_date)
        .where(employee_id: @employee_id).where(order_status_master_id: 10041).order(:external_order_no)

        @total_transfer_value_s = @order_transfer.sum(:subtotal)
        @total_transfer_nos_s = @order_transfer.sum(:pieces)

        @order_refunds = OrderMaster.where('refund_date >= ? AND refund_date <= ?', @from_date, @to_date)
        .where(employee_id: @employee_id).order(:external_order_no)

        @total_refunds_value_s = @order_refunds.sum(:subtotal)
        @total_refunds_nos_s = @order_refunds.sum(:pieces)


    end




      @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
      @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

  end
  #end
  def search
  end

  def details
  end
  def use_from_to_date back_days
    @from_date = Date.current - back_days.days #30.days
    @to_date = Date.current
    if params[:from_date].present?
      #@summary ||= []
      @or_for_date = params[:from_date]
      for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")

      @from_date = for_date.beginning_of_day - 330.minutes
      @to_date = for_date.end_of_day - 330.minutes
      #@to_date = @from_date + 1.day

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end

      @to_date = @to_date.end_of_day - 330.minutes
    end
  end

end
