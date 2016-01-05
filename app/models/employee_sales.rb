class EmployeeSales
  attr_accessor :all_processed_nos, :all_processed_value, :all_processed_earnings, :all_shipped_nos, :all_shipped_value, :all_shipped_earnings,  :all_cancelled_nos, :all_cancelled_value, :all_cancelled_earnings, :all_returned_nos, :all_returned_value, :all_returned_earnings, :all_paid_nos, :all_paid_value, :all_paid_earnings, :last_updated_date, :for_month, :for_year, :sales_data

  def sales_data(for_period, employee_id)
    for_period =  Date.strptime(for_period, "%Y-%m")
    @from_date = for_period.beginning_of_month.beginning_of_day - 330.minutes
    @to_date = for_period.end_of_month.end_of_day - 330.minutes
    #@to_date = @from_date + 1.day
    all_orders = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
    .where(employee_id: employee_id)

    total_orders = all_orders.where('ORDER_STATUS_MASTER_ID > 10002')

    #shipped 10005
    shipped_orders = all_orders.where('ORDER_STATUS_MASTER_ID = 10005')
    # cancelled orders 10006
    cancelled_orders = all_orders.where('ORDER_STATUS_MASTER_ID = 10006')
    # paid_orders 10007
    paid_orders = all_orders.where('ORDER_STATUS_MASTER_ID = 10007')
    # unclaimed_orders returned orders 10008
    unclaimed_orders = all_orders.where('ORDER_STATUS_MASTER_ID = 10008')

    employee_sale = EmployeeSales.new
      employee_sale.all_processed_nos = total_orders.count(:id)
      employee_sale.all_processed_value = total_orders.sum(:total).to_i
      employee_sale.all_processed_earnings = 0
      employee_sale.all_shipped_nos = shipped_orders.count(:id)
      employee_sale.all_shipped_value = shipped_orders.sum(:total).to_i
      employee_sale.all_shipped_earnings = 0
      employee_sale.all_cancelled_nos = cancelled_orders.count(:id)
      employee_sale.all_cancelled_value = cancelled_orders.sum(:total).to_i
      employee_sale.all_cancelled_earnings = 0
      employee_sale.all_returned_nos = unclaimed_orders.count(:id)
      employee_sale.all_returned_value = unclaimed_orders.sum(:total).to_i
      employee_sale.all_returned_earnings = 0
      employee_sale.all_paid_nos = paid_orders.count(:id)
      employee_sale.all_paid_value = paid_orders.sum(:total).to_i
      employee_sale.all_paid_earnings = 0
      employee_sale.last_updated_date = (Date.today - 1.day).strftime("%d-%b-%y")
      employee_sale.for_month = @to_date.strftime("%B")
      employee_sale.for_year = @to_date.strftime("%Y")
    return employee_sale

  end
end
