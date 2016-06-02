class EmployeeSales
  attr_accessor  :last_updated_date, :for_month, :for_year, :sales_data
  
  attr_accessor :all_nos, :all_value, :from_date, :to_date
  
   attr_accessor :all_open_nos, :all_open_value, :all_open_earnings, :all_processed_nos, :all_processed_value, :all_processed_earnings, :all_shipped_nos, :all_shipped_value, :all_shipped_earnings,  :all_cancelled_nos, :all_cancelled_value, :all_cancelled_earnings, :all_returned_nos, :all_returned_value, :all_returned_earnings, :all_paid_nos, :all_paid_value, :all_paid_earnings, :all_actual_nos, :all_actual_value, :all_actual_earnings
 
  attr_accessor :basic_open_nos, :basic_open_value, :basic_open_earnings, :basic_processed_nos, :basic_processed_value, :basic_processed_earnings, :basic_shipped_nos, :basic_shipped_value, :basic_shipped_earnings,  :basic_cancelled_nos, :basic_cancelled_value, :basic_cancelled_earnings, :basic_returned_nos, :basic_returned_value, :basic_returned_earnings, :basic_paid_nos, :basic_paid_value, :basic_paid_earnings, :basic_actual_nos, :basic_actual_value, :basic_actual_earnings
  
 attr_accessor :upsell_open_nos, :upsell_open_value, :upsell_open_earnings, :upsell_processed_nos, :upsell_processed_value, :upsell_processed_earnings, :upsell_shipped_nos, :upsell_shipped_value, :upsell_shipped_earnings,  :upsell_cancelled_nos, :upsell_cancelled_value, :upsell_cancelled_earnings, :upsell_returned_nos, :upsell_returned_value, :upsell_returned_earnings, :upsell_paid_nos, :upsell_paid_value, :upsell_paid_earnings, :upsell_actual_nos, :upsell_actual_value, :upsell_actual_earnings
 
  # Corrected Sales = 100,000 - 10,000 = 90,000
  # Agent commission =  Corrected Sales  * 1% (1%)
  # Manager / Supervisor commission = Corrected Sales * 0.25% (0.25%)
  # Team Coach Commission = Corrected Sales * 0.0625% (25% of 0.25%) 
  # Upsale Product Agent Commission 80% for agents and 20%  for supervisor and  team coaches
  # Commission to supervisor and team coaches at same percentage
  
#   @order_lines_regular = OrderLine.where(orderid: @order_id)
#    .joins(:product_variant)
#    .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
#basic upsell
# @order_lines_basic = OrderLine.where(orderid: @order_id)
# .joins(:product_variant)
# .where('product_variants.product_sell_type_id = ?', 10040)
#common upsell
# @order_lines_common = OrderLine.where(orderid: @order_id)
# .joins(:product_variant)
# .where('product_variants.product_sell_type_id = ?', 10001)
#free upsell
# @order_lines_free = OrderLine.where(orderid: @order_id)
# .joins(:product_variant)
# .where('product_variants.product_sell_type_id = ?', 10060)
# all prices would be basic less taxes
def sales_data(from_date, to_date, employee_id)
   return if from_date.blank? || to_date.blank?
    comm =  0.01 # 1%
    per_c = 0.8 # 80% of upsale
   #for_period =  Date.strptime(for_period, "%Y-%m")
    @from_date = from_date #for_period.beginning_of_month.beginning_of_day - 330.minutes
    @to_date = to_date #or_period.end_of_month.end_of_day - 330.minutes
    #@to_date = @from_date + 1.day
    all_orders = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
    .where(employee_id: employee_id)
    
    ###############################
    # Open Orders orderdate: processed 10003 basic products
    open_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where('order_masters.order_status_master_id > 10002')
        
    open_basic_orders = open_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # process_date: processed 10003 upsell products
    open_upsell_orders = open_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    open_upsell_value = 0
    open_upsell_orders.each {|ord| open_upsell_value += ord.call_centre_commission}
    open_upsell_numbers = open_upsell_orders.count
    ##########################
    
    ###############################
    # process_date: processed 10003 basic products
    basic_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.process_date >= ? AND order_masters.process_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id > 10002')
        
    all_basic_orders = basic_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # process_date: processed 10003 upsell products
    all_upsell_orders = basic_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    all_upsell_value = 0
    all_upsell_orders.each {|ord| all_upsell_value += ord.call_centre_commission}
    all_upsell_numbers = all_upsell_orders.count
    ##########################
    
    
    ###############################
    #     # ship_date shipped 10005 basic products
    shipped_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.ship_date >= ? AND order_masters.ship_date <= ?', @from_date, @to_date)
        
    basic_shipped_orders = shipped_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000) if shipped_orders.present?
    # .where('order_masters.order_status_master_id = 10005')
    
    #     # ship_date shipped 10005 upsell products
    upsell_shipped_orders = shipped_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if shipped_orders.present?
    
    upsell_shipped_value = 0
    upsell_shipped_orders.each {|ord| upsell_shipped_value += ord.call_centre_commission} if upsell_shipped_orders.present?
    upsell_shipped_numbers = upsell_shipped_orders.count || 0 if upsell_shipped_orders.present?
    ##########################
    
    
    ###############################
    # # cancelled_date cancelled orders 10006
    cancelled_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.cancelled_date >= ? AND order_masters.cancelled_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10006')
        
    basic_cancelled_orders = cancelled_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000) if cancelled_orders.present?
    
    # # cancelled_date cancelled orders 10006 upsell products
    upsell_cancelled_orders = cancelled_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if cancelled_orders.present?
    
    upsell_cancelled_value = 0
    upsell_cancelled_orders.each {|ord| upsell_cancelled_value += ord.call_centre_commission} if upsell_cancelled_orders.present?
    upsell_cancelled_numbers = upsell_cancelled_orders.count || 0 if upsell_cancelled_orders.present?
    ##########################
    
    
    ###############################
    # # paid_date paid_orders 10007
    paid_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.paid_date >= ? AND order_masters.paid_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10007')
    
    basic_paid_orders = paid_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # paid_date paid_orders 10007 upsell products
    upsell_paid_orders = paid_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_paid_value = 0
    upsell_paid_orders.each {|ord| upsell_paid_value += ord.call_centre_commission} if upsell_paid_orders.present?
    upsell_paid_numbers = upsell_paid_orders.count || 0 if upsell_paid_orders.present?
    ##########################

    
    ###############################
    # # refund_date  unclaimed_orders   returned orders
    refunded_orders = OrderLine.joins(:order_master)
        .where("order_masters.employee_id = ? ", employee_id)
        .where('order_masters.refund_date >= ? AND order_masters.refund_date <= ?', @from_date, @to_date)
       # .where('order_masters.order_status_master_id = 10008')
    basic_refunded_orders = refunded_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # refund_date  unclaimed_orders   returned orders 10008 upsell products
    upsell_refunded_orders = refunded_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_refunded_value = 0
    upsell_refunded_orders.each {|ord| upsell_refunded_value += ord.call_centre_commission} if upsell_refunded_orders.present?
    upsell_refunded_numbers = upsell_refunded_orders.count || 0 if upsell_refunded_orders.present?
    ##########################

    ##########
    
    employee_sale = EmployeeSales.new
      employee_sale.from_date = from_date + 330.minutes
      employee_sale.to_date = to_date + 330.minutes
      employee_sale.all_nos = all_orders.count
      employee_sale.all_value = (all_orders.sum(:subtotal) * 0.888888).to_i
      
      employee_sale.basic_processed_nos = all_basic_orders.distinct.count(:orderid) || 0 if all_basic_orders.present?
      employee_sale.basic_processed_value = (all_basic_orders.sum(:subtotal) * 0.888888).to_i || 0 if all_basic_orders.present?
      employee_sale.basic_processed_earnings = ((all_basic_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if all_basic_orders.present?

      employee_sale.basic_shipped_nos = basic_shipped_orders.distinct.count(:orderid) || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_value = (basic_shipped_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_earnings = ((basic_shipped_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_shipped_orders.present?

      employee_sale.basic_cancelled_nos = basic_cancelled_orders.distinct.count(:orderid) || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_value = (basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i  || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_earnings = ((basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i  || 0 if basic_cancelled_orders.present?

      employee_sale.basic_returned_nos = basic_refunded_orders.distinct.count(:orderid) || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_value = (basic_refunded_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_earnings = ((basic_refunded_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_refunded_orders.present?

      employee_sale.basic_paid_nos = basic_paid_orders.distinct.count(:orderid) || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_value = (basic_paid_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_earnings = ((basic_paid_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_paid_orders.present?
      
      employee_sale.basic_open_nos = (employee_sale.basic_processed_nos.to_i || 0) - ((employee_sale.basic_shipped_nos || 0) + (employee_sale.basic_cancelled_nos || 0) +  (employee_sale.basic_returned_nos || 0) + (employee_sale.basic_paid_nos || 0 )).to_i
         
      employee_sale.basic_open_value = (employee_sale.basic_processed_value.to_i || 0) - ((employee_sale.basic_shipped_value || 0) + (employee_sale.basic_cancelled_value || 0) +  (employee_sale.basic_returned_value || 0) + (employee_sale.basic_paid_value || 0)).to_i
      employee_sale.basic_open_earnings = 0
      
      employee_sale.basic_actual_nos = employee_sale.basic_paid_nos.to_i - employee_sale.basic_returned_nos.to_i 
      employee_sale.basic_actual_value = employee_sale.basic_paid_value.to_i - employee_sale.basic_returned_value.to_i 
      employee_sale.basic_actual_earnings = (((employee_sale.basic_paid_value ||= 0) - (employee_sale.basic_returned_value ||= 0)) * comm).to_i 
      ##################
      
      employee_sale.upsell_processed_nos = all_upsell_numbers || 0 if all_upsell_numbers.present?
      employee_sale.upsell_processed_value = (all_upsell_value).to_i || 0 if all_upsell_value.present?
      employee_sale.upsell_processed_earnings = (all_upsell_value * per_c).to_i || 0 if all_upsell_value.present?

      employee_sale.upsell_shipped_nos = upsell_shipped_numbers || 0 if upsell_paid_numbers.present?
      employee_sale.upsell_shipped_value = (upsell_shipped_value).to_i || 0 if upsell_shipped_value.present?
      employee_sale.upsell_shipped_earnings = (upsell_shipped_value * per_c).to_i || 0 if upsell_paid_value.present?

      employee_sale.upsell_cancelled_nos = upsell_shipped_numbers || 0 if upsell_paid_numbers.present?
      employee_sale.upsell_cancelled_value = (upsell_shipped_value).to_i || 0 if upsell_shipped_value.present?
      employee_sale.upsell_cancelled_earnings = (upsell_shipped_value * per_c).to_i || 0 if upsell_paid_value.present?

      employee_sale.upsell_returned_nos = upsell_refunded_numbers || 0 if upsell_refunded_numbers.present?
      employee_sale.upsell_returned_value = (upsell_refunded_value).to_i || 0 if upsell_refunded_value.present?
      employee_sale.upsell_returned_earnings = (upsell_refunded_value * per_c).to_i || 0 if upsell_refunded_value.present?

      employee_sale.upsell_paid_nos = upsell_paid_orders.distinct.count('orderid') || 0 if upsell_paid_orders.present?
      employee_sale.upsell_paid_value = (upsell_paid_value).to_i || 0 if upsell_paid_value.present?
      employee_sale.upsell_paid_earnings = (upsell_paid_value * per_c).to_i || 0 if upsell_paid_value.present?
      
      employee_sale.upsell_open_nos = (employee_sale.upsell_processed_nos.to_i || 0) - ((employee_sale.upsell_shipped_nos || 0) + (employee_sale.upsell_cancelled_nos || 0) +  (employee_sale.upsell_returned_nos || 0) + (employee_sale.upsell_paid_nos || 0)).to_i   
      employee_sale.upsell_open_value = (employee_sale.upsell_processed_value.to_i || 0) - ((employee_sale.upsell_shipped_value || 0) + (employee_sale.upsell_cancelled_value || 0) +  (employee_sale.upsell_returned_value || 0) + (employee_sale.upsell_paid_value || 0)).to_i
      employee_sale.upsell_open_earnings = 0
      
      employee_sale.upsell_actual_nos = employee_sale.upsell_paid_nos.to_i - employee_sale.upsell_returned_nos.to_i
      employee_sale.upsell_actual_value = employee_sale.upsell_paid_value.to_i - employee_sale.upsell_returned_value.to_i
      employee_sale.upsell_actual_earnings = employee_sale.upsell_paid_earnings.to_i - employee_sale.upsell_returned_earnings.to_i
      
      ##################
      employee_sale.all_processed_nos = employee_sale.basic_processed_nos ||= 0
      employee_sale.all_processed_value =  (employee_sale.upsell_processed_value ||= 0) + (employee_sale.basic_processed_value ||= 0)
      employee_sale.all_processed_earnings = (employee_sale.basic_processed_earnings ||= 0 ) + (employee_sale.upsell_processed_earnings ||= 0)
      
      employee_sale.all_shipped_nos = employee_sale.basic_shipped_nos ||= 0#+ employee_sale.upsell_shipped_nos
      employee_sale.all_shipped_value = (employee_sale.basic_shipped_value ||= 0) + (employee_sale.upsell_shipped_value ||= 0)
      employee_sale.all_shipped_earnings = (employee_sale.basic_shipped_earnings ||= 0) + (employee_sale.upsell_shipped_earnings ||= 0)
      
      employee_sale.all_cancelled_nos = employee_sale.basic_cancelled_nos ||= 0 #+ employee_sale.upsell_cancelled_nos
      employee_sale.all_cancelled_value = (employee_sale.basic_cancelled_value ||= 0) + (employee_sale.upsell_cancelled_value ||= 0)
      employee_sale.all_cancelled_earnings = (employee_sale.basic_cancelled_earnings ||= 0) + (employee_sale.upsell_cancelled_earnings ||= 0)
      
      employee_sale.all_returned_nos = employee_sale.basic_returned_nos ||= 0 #+ employee_sale.upsell_returned_nos
      employee_sale.all_returned_value = (employee_sale.basic_returned_value ||= 0) + (employee_sale.upsell_returned_value ||= 0)
      employee_sale.all_returned_earnings = (employee_sale.basic_returned_earnings ||= 0) + (employee_sale.upsell_returned_earnings ||= 0)
      
      employee_sale.all_paid_nos = employee_sale.basic_paid_nos #+ employee_sale.upsell_paid_nos
      employee_sale.all_paid_value = (employee_sale.basic_paid_value ||= 0) + (employee_sale.upsell_paid_value ||= 0)
      employee_sale.all_paid_earnings = (employee_sale.basic_paid_earnings ||= 0) + (employee_sale.upsell_paid_earnings ||= 0)
      
      employee_sale.all_actual_nos = employee_sale.all_paid_nos.to_i - employee_sale.all_returned_nos.to_i 
      employee_sale.all_actual_value = employee_sale.all_paid_value.to_i - employee_sale.all_returned_value.to_i 
      employee_sale.all_actual_earnings = (employee_sale.basic_actual_earnings ||= 0) + (employee_sale.upsell_actual_earnings ||= 0)
      
      ##################
      employee_sale.last_updated_date = (Date.today - 1.day).strftime("%d-%b-%y")
      employee_sale.for_month = @to_date.strftime("%B")
      employee_sale.for_year = @to_date.strftime("%Y")
    return employee_sale
end
  
def supervisor_sales_data from_date, to_date
   return if from_date.blank? || to_date.blank?
    comm =  0.0002083 #0.00625 / 3
    per_c = 0.05 # 0.2 / 4
   # for_period =  Date.strptime(for_period, "%Y-%m")
    @from_date = from_date #for_period.beginning_of_month.beginning_of_day - 330.minutes
    @to_date = to_date #for_period.end_of_month.end_of_day - 330.minutes
    #@to_date = @from_date + 1.day
    all_orders = nil #  OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
  
    
    ###############################
    # process_date: processed 10003 basic products
    basic_orders = nil # OrderLine.joins(:order_master).where('order_masters.process_date >= ? AND order_masters.process_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id > 10002')
        
    all_basic_orders = nil # basic_orders.joins(:product_variant).where("product_variants.product_sell_type_id = ?", 10000)
    
    # process_date: processed 10003 upsell products
    all_upsell_orders = nil # basic_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    all_upsell_value = 0
    all_upsell_orders.each {|ord| all_upsell_value += ord.call_centre_commission} if all_upsell_orders.present?
    all_upsell_numbers = all_upsell_orders.count if all_upsell_orders.present?
    ##########################
    
    
    ###############################
    #     # ship_date shipped 10005 basic products
    shipped_orders = nil # OrderLine.joins(:order_master).where('order_masters.ship_date >= ? AND order_masters.ship_date <= ?', @from_date, @to_date)
        
    basic_shipped_orders = nil # shipped_orders.joins(:product_variant.where("product_variants.product_sell_type_id = ?", 10000) if shipped_orders.present?
    # .where('order_masters.order_status_master_id = 10005')
    
    #     # ship_date shipped 10005 upsell products
    upsell_shipped_orders = nil # shipped_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if shipped_orders.present?
    
    upsell_shipped_value = 0
    upsell_shipped_orders.each {|ord| upsell_shipped_value += ord.call_centre_commission} if upsell_shipped_orders.present?
    upsell_shipped_numbers = upsell_shipped_orders.count || 0 if upsell_shipped_orders.present?
    ##########################
    
    
    ###############################
    # # cancelled_date cancelled orders 10006
    cancelled_orders = nil # OrderLine.joins(:order_master).where('order_masters.cancelled_date >= ? AND order_masters.cancelled_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10006')
        
    basic_cancelled_orders = nil # cancelled_orders.joins(:product_variant).where("product_variants.product_sell_type_id = ?", 10000) if cancelled_orders.present?
    
    # # cancelled_date cancelled orders 10006 upsell products
    upsell_cancelled_orders = nil # cancelled_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if cancelled_orders.present?
    
    upsell_cancelled_value = 0
    upsell_cancelled_orders.each {|ord| upsell_cancelled_value += ord.call_centre_commission} if upsell_cancelled_orders.present?
    upsell_cancelled_numbers = upsell_cancelled_orders.count || 0 if upsell_cancelled_orders.present?
    ##########################
    
    
    ###############################
    # # paid_date paid_orders 10007
    paid_orders = OrderLine.joins(:order_master)
        .where('order_masters.paid_date >= ? AND order_masters.paid_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10007')
    
    basic_paid_orders = paid_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # paid_date paid_orders 10007 upsell products
    upsell_paid_orders = paid_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_paid_value = 0
    upsell_paid_orders.each {|ord| upsell_paid_value += ord.call_centre_commission} if upsell_paid_orders.present?
    upsell_paid_numbers = upsell_paid_orders.count || 0 if upsell_paid_orders.present?
    ##########################

    
    ###############################
    # # refund_date  unclaimed_orders   returned orders
    refunded_orders = OrderLine.joins(:order_master)
        .where('order_masters.refund_date >= ? AND order_masters.refund_date <= ?', @from_date, @to_date)
       # .where('order_masters.order_status_master_id = 10008')
    basic_refunded_orders = refunded_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # refund_date  unclaimed_orders   returned orders 10008 upsell products
    upsell_refunded_orders = refunded_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_refunded_value = 0
    upsell_refunded_orders.each {|ord| upsell_refunded_value += ord.call_centre_commission} if upsell_refunded_orders.present?
    upsell_refunded_numbers = upsell_refunded_orders.count || 0 if upsell_refunded_orders.present?
    ##########################

    ##########
    
    employee_sale = EmployeeSales.new
    employee_sale.from_date = from_date + 330.minutes
    employee_sale.to_date = to_date + 330.minutes
      employee_sale.all_nos = all_orders.count if all_orders.present?
      employee_sale.all_value = ((all_orders.sum(:subtotal) * 0.888888).to_i) if all_orders.present?
      
      employee_sale.basic_processed_nos = all_basic_orders.distinct.count(:orderid) || 0 if all_basic_orders.present?
      employee_sale.basic_processed_value = (all_basic_orders.sum(:subtotal) * 0.888888).to_i || 0 if all_basic_orders.present?
      employee_sale.basic_processed_earnings = ((all_basic_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if all_basic_orders.present?

      employee_sale.basic_shipped_nos = basic_shipped_orders.distinct.count(:orderid) || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_value = (basic_shipped_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_earnings = ((basic_shipped_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_shipped_orders.present?

      employee_sale.basic_cancelled_nos = basic_cancelled_orders.distinct.count(:orderid) || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_value = (basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i  || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_earnings = ((basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i  || 0 if basic_cancelled_orders.present?

      employee_sale.basic_returned_nos = basic_refunded_orders.distinct.count(:orderid) || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_value = (basic_refunded_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_earnings = ((basic_refunded_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_refunded_orders.present?

      employee_sale.basic_paid_nos = basic_paid_orders.distinct.count(:orderid) || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_value = (basic_paid_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_earnings = ((basic_paid_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_paid_orders.present?

      employee_sale.basic_actual_nos = employee_sale.basic_paid_nos.to_i - employee_sale.basic_returned_nos.to_i 
      employee_sale.basic_actual_value = employee_sale.basic_paid_value.to_i - employee_sale.basic_returned_value.to_i 
      employee_sale.basic_actual_earnings = (((employee_sale.basic_paid_value ||= 0) - (employee_sale.basic_returned_value ||= 0)) * comm).to_i 
      ##################
      
      employee_sale.upsell_processed_nos = all_upsell_numbers || 0 if all_upsell_numbers.present?
      employee_sale.upsell_processed_value = (all_upsell_value).to_i || 0 if all_upsell_value.present?
      employee_sale.upsell_processed_earnings = (all_upsell_value * per_c).to_i || 0 if all_upsell_value.present?

      employee_sale.upsell_shipped_nos = upsell_shipped_numbers || 0 if upsell_shipped_numbers.present?
      employee_sale.upsell_shipped_value = (upsell_shipped_value).to_i || 0 if upsell_shipped_value.present?
      employee_sale.upsell_shipped_earnings = (upsell_shipped_value * per_c).to_i || 0 if upsell_shipped_value.present?

      employee_sale.upsell_cancelled_nos = upsell_cancelled_numbers || 0 if upsell_cancelled_numbers.present?
      employee_sale.upsell_cancelled_value = (upsell_cancelled_value).to_i || 0 if upsell_cancelled_value.present?
      employee_sale.upsell_cancelled_earnings = (upsell_cancelled_value * per_c).to_i || 0 if upsell_cancelled_value.present?

      employee_sale.upsell_returned_nos = upsell_refunded_numbers || 0 if upsell_refunded_numbers.present?
      employee_sale.upsell_returned_value = (upsell_refunded_value).to_i || 0 if upsell_refunded_value.present?
      employee_sale.upsell_returned_earnings = (upsell_refunded_value * per_c).to_i || 0 if upsell_refunded_value.present?

      employee_sale.upsell_paid_nos = upsell_paid_numbers || 0 if upsell_paid_numbers.present?
      employee_sale.upsell_paid_value = (upsell_paid_value).to_i || 0 if upsell_paid_value.present?
      employee_sale.upsell_paid_earnings = (upsell_paid_value * per_c).to_i || 0 if upsell_paid_value.present?

      employee_sale.upsell_actual_nos = (employee_sale.upsell_paid_nos || 0) - (employee_sale.upsell_returned_nos || 0)
      employee_sale.upsell_actual_value = (employee_sale.upsell_paid_value.to_i || 0) - (employee_sale.upsell_returned_value.to_i || 0)
      employee_sale.upsell_actual_earnings = employee_sale.upsell_paid_earnings.to_i - employee_sale.upsell_returned_earnings.to_i
      
      ##################
      employee_sale.all_processed_nos = employee_sale.basic_processed_nos
      employee_sale.all_processed_value =  (employee_sale.upsell_processed_value ||= 0) + (employee_sale.basic_processed_value ||= 0)
      employee_sale.all_processed_earnings = (employee_sale.basic_processed_earnings ||= 0 ) + (employee_sale.upsell_processed_earnings ||= 0)
      
      employee_sale.all_shipped_nos = employee_sale.basic_shipped_nos #+ employee_sale.upsell_shipped_nos
      employee_sale.all_shipped_value = (employee_sale.basic_shipped_value ||= 0) + (employee_sale.upsell_shipped_value ||= 0)
      employee_sale.all_shipped_earnings = (employee_sale.basic_shipped_earnings ||= 0) + (employee_sale.upsell_shipped_earnings ||= 0)
      
      employee_sale.all_cancelled_nos = employee_sale.basic_cancelled_nos #+ employee_sale.upsell_cancelled_nos
      employee_sale.all_cancelled_value = (employee_sale.basic_cancelled_value ||= 0) + (employee_sale.upsell_cancelled_value ||= 0)
      employee_sale.all_cancelled_earnings = (employee_sale.basic_cancelled_earnings ||= 0) + (employee_sale.upsell_cancelled_earnings ||= 0)
      
      employee_sale.all_returned_nos = employee_sale.basic_returned_nos #+ employee_sale.upsell_returned_nos
      employee_sale.all_returned_value = (employee_sale.basic_returned_value ||= 0) + (employee_sale.upsell_returned_value ||= 0)
      employee_sale.all_returned_earnings = (employee_sale.basic_returned_earnings ||= 0) + (employee_sale.upsell_returned_earnings ||= 0)
      
      employee_sale.all_paid_nos = employee_sale.basic_paid_nos #+ employee_sale.upsell_paid_nos
      employee_sale.all_paid_value = (employee_sale.basic_paid_value ||= 0) + (employee_sale.upsell_paid_value ||= 0)
      employee_sale.all_paid_earnings = (employee_sale.basic_paid_earnings ||= 0) + (employee_sale.upsell_paid_earnings ||= 0)
      
      employee_sale.all_actual_nos = employee_sale.all_paid_nos.to_i - employee_sale.all_returned_nos.to_i 
      employee_sale.all_actual_value = employee_sale.all_paid_value.to_i - employee_sale.all_returned_value.to_i 
      employee_sale.all_actual_earnings = (employee_sale.basic_actual_earnings ||= 0) + (employee_sale.upsell_actual_earnings ||= 0)
      
      ##################
      employee_sale.last_updated_date = (Date.today - 1.day).strftime("%d-%b-%y")
      employee_sale.for_month = @to_date.strftime("%B")
      employee_sale.for_year = @to_date.strftime("%Y")
    return employee_sale
end
  
def manager_sales_data from_date, to_date
   return if from_date.blank? || to_date.blank?
    comm =  0.0025 #0.00625 / 3
    per_c = 0.05 # 0.2 / 4
    #for_period =  Date.strptime(for_period, "%Y-%m")
    @from_date = from_date #for_period.beginning_of_month.beginning_of_day - 330.minutes
    @to_date = to_date #for_period.end_of_month.end_of_day - 330.minutes
  
    all_orders = nil #  OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
  
    
    ###############################
    # process_date: processed 10003 basic products
    basic_orders = nil # OrderLine.joins(:order_master).where('order_masters.process_date >= ? AND order_masters.process_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id > 10002')
        
    all_basic_orders = nil # basic_orders.joins(:product_variant).where("product_variants.product_sell_type_id = ?", 10000)
    
    # process_date: processed 10003 upsell products
    all_upsell_orders = nil # basic_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    all_upsell_value = 0
    all_upsell_orders.each {|ord| all_upsell_value += ord.call_centre_commission} if all_upsell_orders.present?
    all_upsell_numbers = all_upsell_orders.count if all_upsell_orders.present?
    ##########################
    
    
    ###############################
    #     # ship_date shipped 10005 basic products
    shipped_orders = nil # OrderLine.joins(:order_master).where('order_masters.ship_date >= ? AND order_masters.ship_date <= ?', @from_date, @to_date)
        
    basic_shipped_orders = nil # shipped_orders.joins(:product_variant.where("product_variants.product_sell_type_id = ?", 10000) if shipped_orders.present?
    # .where('order_masters.order_status_master_id = 10005')
    
    #     # ship_date shipped 10005 upsell products
    upsell_shipped_orders = nil # shipped_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if shipped_orders.present?
    
    shipped_upsell_value = 0
    upsell_shipped_orders.each {|ord| shipped_upsell_value += ord.call_centre_commission} if upsell_shipped_orders.present?
    
    upsell_shipped_numbers = upsell_shipped_orders.count || 0 if upsell_shipped_orders.present?
    ##########################
    
    
    ###############################
    # # cancelled_date cancelled orders 10006
    cancelled_orders = nil # OrderLine.joins(:order_master).where('order_masters.cancelled_date >= ? AND order_masters.cancelled_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10006')
        
    basic_cancelled_orders = nil # cancelled_orders.joins(:product_variant).where("product_variants.product_sell_type_id = ?", 10000) if cancelled_orders.present?
    
    # # cancelled_date cancelled orders 10006 upsell products
    upsell_cancelled_orders = nil # cancelled_orders.joins(:product_variant).where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000) if cancelled_orders.present?
    
    upsell_cancelled_value = 0
    upsell_cancelled_orders.each {|ord| upsell_cancelled_value += ord.call_centre_commission} if upsell_cancelled_orders.present?
    upsell_cancelled_numbers = upsell_cancelled_orders.count || 0 if upsell_cancelled_orders.present?
    ##########################
    
    
    ###############################
    # # paid_date paid_orders 10007
    paid_orders = OrderLine.joins(:order_master)
        .where('order_masters.paid_date >= ? AND order_masters.paid_date <= ?', @from_date, @to_date)
        #.where('order_masters.order_status_master_id = 10007')
    
    basic_paid_orders = paid_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # paid_date paid_orders 10007 upsell products
    upsell_paid_orders = paid_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_paid_value = 0
    upsell_paid_orders.each {|ord| upsell_paid_value += ord.call_centre_commission} if upsell_paid_orders.present?
    upsell_paid_numbers = upsell_paid_orders.count || 0 if upsell_paid_orders.present?
    ##########################

    
    ###############################
    # # refund_date  unclaimed_orders   returned orders
    refunded_orders = OrderLine.joins(:order_master)
        .where('order_masters.refund_date >= ? AND order_masters.refund_date <= ?', @from_date, @to_date)
       # .where('order_masters.order_status_master_id = 10008')
    basic_refunded_orders = refunded_orders.joins(:product_variant)
    .where("product_variants.product_sell_type_id = ?", 10000)
    
    # # refund_date  unclaimed_orders   returned orders 10008 upsell products
    upsell_refunded_orders = refunded_orders.joins(:product_variant)
    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
    
    upsell_refunded_value = 0
    upsell_refunded_orders.each {|ord| upsell_refunded_value += ord.call_centre_commission} if upsell_refunded_orders.present?
    upsell_refunded_numbers = upsell_refunded_orders.count || 0 if upsell_refunded_orders.present?
    ##########################

    ##########
    
    employee_sale = EmployeeSales.new
    employee_sale.from_date = from_date + 330.minutes
    employee_sale.to_date = to_date + 330.minutes
      employee_sale.all_nos = all_orders.count if all_orders.present?
      employee_sale.all_value = ((all_orders.sum(:subtotal) * 0.888888).to_i) if all_orders.present?
      
      employee_sale.basic_processed_nos = all_basic_orders.distinct.count(:orderid) || 0 if all_basic_orders.present?
      employee_sale.basic_processed_value = (all_basic_orders.sum(:subtotal) * 0.888888).to_i || 0 if all_basic_orders.present?
      employee_sale.basic_processed_earnings = ((all_basic_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if all_basic_orders.present?

      employee_sale.basic_shipped_nos = basic_shipped_orders.distinct.count(:orderid) || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_value = (basic_shipped_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_shipped_orders.present?
      employee_sale.basic_shipped_earnings = ((basic_shipped_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_shipped_orders.present?

      employee_sale.basic_cancelled_nos = basic_cancelled_orders.distinct.count(:orderid) || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_value = (basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i  || 0 if basic_cancelled_orders.present?
      employee_sale.basic_cancelled_earnings = ((basic_cancelled_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i  || 0 if basic_cancelled_orders.present?

      employee_sale.basic_returned_nos = basic_refunded_orders.distinct.count(:orderid) || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_value = (basic_refunded_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_refunded_orders.present?
      employee_sale.basic_returned_earnings = ((basic_refunded_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_refunded_orders.present?

      employee_sale.basic_paid_nos = basic_paid_orders.distinct.count(:orderid) || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_value = (basic_paid_orders.sum(:subtotal) * 0.888888).to_i || 0 if basic_paid_orders.present?
      employee_sale.basic_paid_earnings = ((basic_paid_orders.sum(:subtotal) * 0.888888).to_i * comm).to_i || 0 if basic_paid_orders.present?

      employee_sale.basic_actual_nos = employee_sale.basic_paid_nos.to_i - employee_sale.basic_returned_nos.to_i 
      employee_sale.basic_actual_value = employee_sale.basic_paid_value.to_i - employee_sale.basic_returned_value.to_i 
      employee_sale.basic_actual_earnings = (((employee_sale.basic_paid_value ||= 0) - (employee_sale.basic_returned_value ||= 0)) * comm).to_i 
      ##################
      
      employee_sale.upsell_processed_nos = all_upsell_numbers || 0 if all_upsell_numbers.present?
      employee_sale.upsell_processed_value = (all_upsell_value).to_i || 0 if all_upsell_value.present?
      employee_sale.upsell_processed_earnings = (all_upsell_value * per_c).to_i || 0 if all_upsell_value.present?

      employee_sale.upsell_shipped_nos = upsell_shipped_numbers || 0 if upsell_shipped_numbers.present?
      employee_sale.upsell_shipped_value = (upsell_shipped_value).to_i || 0 if upsell_shipped_value.present?
      employee_sale.upsell_shipped_earnings = (upsell_shipped_value * per_c).to_i || 0 if upsell_shipped_value.present?

      employee_sale.upsell_cancelled_nos = upsell_cancelled_numbers || 0 if upsell_cancelled_numbers.present?
      employee_sale.upsell_cancelled_value = (upsell_cancelled_value).to_i || 0 if upsell_cancelled_value.present?
      employee_sale.upsell_cancelled_earnings = (upsell_cancelled_value * per_c).to_i || 0 if upsell_cancelled_value.present?

      employee_sale.upsell_returned_nos = upsell_refunded_value || 0 if upsell_refunded_numbers.present?
      employee_sale.upsell_returned_value = (upsell_refunded_value).to_i || 0 if upsell_refunded_value.present?
      employee_sale.upsell_returned_earnings = (upsell_refunded_value * per_c).to_i || 0 if upsell_refunded_value.present?

      employee_sale.upsell_paid_nos = upsell_paid_orders.distinct.count('orderid') || 0 if upsell_paid_orders.present?
      employee_sale.upsell_paid_value = (upsell_paid_value).to_i || 0 if upsell_paid_value.present?
      employee_sale.upsell_paid_earnings = (upsell_paid_value * per_c).to_i || 0 if upsell_paid_value.present?

      employee_sale.upsell_actual_nos = employee_sale.upsell_paid_nos.to_i - employee_sale.upsell_returned_nos.to_i
      employee_sale.upsell_actual_value = employee_sale.upsell_paid_value.to_i - employee_sale.upsell_returned_value.to_i
      employee_sale.upsell_actual_earnings = employee_sale.upsell_paid_earnings.to_i - employee_sale.upsell_returned_earnings.to_i
      
      ##################
      employee_sale.all_processed_nos = employee_sale.basic_processed_nos
      employee_sale.all_processed_value =  (employee_sale.upsell_processed_value ||= 0) + (employee_sale.basic_processed_value ||= 0)
      employee_sale.all_processed_earnings = (employee_sale.basic_processed_earnings ||= 0 ) + (employee_sale.upsell_processed_earnings ||= 0)
      
      employee_sale.all_shipped_nos = employee_sale.basic_shipped_nos #+ employee_sale.upsell_shipped_nos
      employee_sale.all_shipped_value = (employee_sale.basic_shipped_value ||= 0) + (employee_sale.upsell_shipped_value ||= 0)
      employee_sale.all_shipped_earnings = (employee_sale.basic_shipped_earnings ||= 0) + (employee_sale.upsell_shipped_earnings ||= 0)
      
      employee_sale.all_cancelled_nos = employee_sale.basic_cancelled_nos #+ employee_sale.upsell_cancelled_nos
      employee_sale.all_cancelled_value = (employee_sale.basic_cancelled_value ||= 0) + (employee_sale.upsell_cancelled_value ||= 0)
      employee_sale.all_cancelled_earnings = (employee_sale.basic_cancelled_earnings ||= 0) + (employee_sale.upsell_cancelled_earnings ||= 0)
      
      employee_sale.all_returned_nos = employee_sale.basic_returned_nos #+ employee_sale.upsell_returned_nos
      employee_sale.all_returned_value = (employee_sale.basic_returned_value ||= 0) + (employee_sale.upsell_returned_value ||= 0)
      employee_sale.all_returned_earnings = (employee_sale.basic_returned_earnings ||= 0) + (employee_sale.upsell_returned_earnings ||= 0)
      
      employee_sale.all_paid_nos = employee_sale.basic_paid_nos #+ employee_sale.upsell_paid_nos
      employee_sale.all_paid_value = (employee_sale.basic_paid_value ||= 0) + (employee_sale.upsell_paid_value ||= 0)
      employee_sale.all_paid_earnings = (employee_sale.basic_paid_earnings ||= 0) + (employee_sale.upsell_paid_earnings ||= 0)
      
      employee_sale.all_actual_nos = employee_sale.all_paid_nos.to_i - employee_sale.all_returned_nos.to_i 
      employee_sale.all_actual_value = employee_sale.all_paid_value.to_i - employee_sale.all_returned_value.to_i 
      employee_sale.all_actual_earnings = (employee_sale.basic_actual_earnings ||= 0) + (employee_sale.upsell_actual_earnings ||= 0)
      
      ##################
      employee_sale.last_updated_date = (Date.today - 1.day).strftime("%d-%b-%y")
      employee_sale.for_month = @to_date.strftime("%B")
      employee_sale.for_year = @to_date.strftime("%Y")
    return employee_sale
end

end
