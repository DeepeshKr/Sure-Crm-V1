class CustdetailsController < ApplicationController
  before_action { protect_controllers(8) } 
  before_action :all_cancelled_orders
	respond_to :html
  def list
  	if params[:from_date].present? && params[:to_date].present?
        #prod = params[:prod]
        from_date = Time.strptime(params[:from_date], '%m/%d/%Y') #- 1.days
        to_date = Time.strptime(params[:to_date], '%m/%d/%Y') 
         @from_date = from_date.to_formatted_s(:rfc822)
        @to_date =  (to_date).to_formatted_s(:rfc822) 
    	
    	 @custdetails = CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date)
			if @custdetails.present?
			  presummary = @custdetails.group(:channel).sum(:totalamt)
			#presummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group(:channel).sum(:totalamt)
			#@datesummary =	@custdetails.count(:group => ["DATE(orderdate)"])
			#@datesummary = @custdetails.group("DATE(orderdate)").sum(:totalamt)
			#@datesummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group(:orderdate).sum(:totalamt)
			# @hoursummary =  CUSTDETAILS.where("TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?", from_date, to_date).group('EXTRACT(HOUR FROM orderdate)').order('EXTRACT(HOUR from orderdate)').count.sum(:totalamt)
			 @summary = presummary.sort_by{|k,v| v}.reverse 
			end

    elsif params[:ordernum].present?
           @custdetails = CUSTDETAILS.where("ORDERNUM = ?", params[:ordernum])
	 end	
    respond_with(@custdetails)
  end
  
  def search
    if params[:ordernum].present?
      @ordernum = params[:ordernum]
      @custdetails = CUSTDETAILS.where("ORDERNUM = ?", params[:ordernum])
      
      if @custdetails.present?
        order_masters = OrderMaster.where(external_order_no: params[:ordernum])
        if order_masters.present?
          #if @order_master.customer_address_id.present?
            @customer_address = CustomerAddress.find(order_masters.first.customer_address_id)
            @order_master = order_masters.first
            @order_lines = OrderLine.where(orderid: @order_master.id).order("id")
          #end 
        end  
      else
        @ordersearchresults = "No Results found for search #{@ordernum}"
      end
    end
    @ordersearchresults = "Please search for Order Results shown in Oracle and Sure CRM"
  end
  
  def details
   
    @total_nos = 0
    @total_value = 0
    @sno = 1
          
     if params[:from_date].present?
       @or_for_date = params[:from_date]
       @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
       @to_date = @from_date
       if params.has_key?(:to_date)
         @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
       end
     end
     
     if params.has_key?(:channel)
       @channel =  params[:channel].strip.upcase
     end
     
     if (@channel == nil || @from_date == nil || @to_date == nil)
       flash[:success] = "No details found to show results"
       return
     end
     
     if ((@to_date - @from_date).to_i > 7 || (@to_date - @from_date).to_i < 0 )
       flash[:error] = "Choose a range between 7 days, this is CUSTDETAILS we are searching, currently you have searched for #{(@to_date - @from_date).to_i} days between #{@from_date} to #{@to_date}"
       return
     end
     
     @ex_from_date = @from_date.beginning_of_day - 330.minutes
     @ex_to_date = @to_date.end_of_day - 330.minutes
     
     employeeunorderlist ||= []
     @num = 0
     amount = 0
       
     # ELECT "ORDER_MASTERS".* FROM "ORDER_MASTERS" WHERE (orderdate >= TO_DATE('2016-07-31 18:30:00','YYYY-MM-DD HH24:MI:SS') AND orderdate <= TO_TIMESTAMP('2016-08-01 18:29:59:000000','YYYY-MM-DD HH24:MI:SS:FF6')) AND (ORDER_STATUS_MASTER_ID > 10000) AND ("ORDER_MASTERS"."ORDER_STATUS_MASTER_ID" NOT IN (10040, 10006, 10008)) AND "ORDER_MASTERS"."MEDIA_ID" = :a1  [["media_id", 11780]]
      begin
        # do something 
        order_master_calculations = CUSTDETAILS.where(:channel.upcase => @channel.upcase)
        .where('TRUNC(in_date) >= ? AND TRUNC(in_date)<= ?', @from_date, @to_date)
        .order(:ordernum)
      
      rescue ActiveRecord::RecordNotFound
        # handle not found error
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue ActiveRecord::ActiveRecordError
        # handle other ActiveRecord errors
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue # StandardError
        # handle most other errors
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue Exception
        # handle everything else
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      end
      
      if order_master_calculations.blank?
        flash[:success] = "No custdetails found when searching between #{@from_date} to #{@to_date}"
        return
      end
      
      @custdetails_order = order_master_calculations.count
      @first_custdetails_order = order_master_calculations.first.ordernum
      @last_custdetails_order = order_master_calculations.last.ordernum
      
       @custdetails_order_list = order_master_calculations.pluck(:ordernum)
      
      order_masters = OrderMaster.where(:channel.upcase => @channel.upcase)
      .where('TRUNC(in_date) >= ? AND TRUNC(in_date)<= ?', @full_from_date, @full_to_date)
      
      @media = Medium.where(:name => @channel, active: 1).pluck(:id)
         
      if @media.blank?
        flash[:success] = "No media details found when searching for #{@channel} or it is not active"
        return
      end
           
     
      
      @ex_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @ex_from_date, @ex_to_date)
                          .where('ORDER_STATUS_MASTER_ID > 10000')
                          .where(media_id: @media)
                          .order(:external_order_no)
      
      if @ex_order_masters.blank?
        flash[:success] = "No orders found when searching for #{@channel} between #{@from_date} to #{@to_date}"
        return
      end
      #@ex_new_orders = "Wow nothing missed"
      if @custdetails_order_list.count > 999
        flash[:error] = "OCIError: ORA-01795: maximum number of expressions in a list is 1000, means Oracle has limit of 1000 cross checks, this reports requires about #{@custdetails_order_list.count} records, you can reduce the date range."
        return
      end
      @ex_new_orders = @ex_order_masters.where.not(external_order_no: @custdetails_order_list).pluck(:external_order_no) 
      
      # @missing_order_cross_check = CustomerOrderList.where(ordernum: @ex_new_orders).pluck(:id, :created_at, :ordernum)
      
      @missing_order_cross_check = CustomerOrderList.where(ordernum: @ex_new_orders)
      #.pluck(:id, :created_at, :ordernum, :order_ref)
      
      @ex_pay_u_money_order = @ex_order_masters.where(orderpaymentmode_id: 10080).where("order_status_master_id < 10003").count
      @ex_processed_orders = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).count(:external_order_no)
      @ex_cancelled_orders = @ex_order_masters.where(ORDER_STATUS_MASTER_ID: @cancelled_status_id).count(:external_order_no)
      @first_all_ex_order_master = @ex_order_masters.first.external_order_no
      @first_ex_order_master = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).first.external_order_no
      @last_ex_order_master = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).last.external_order_no
      @last_all_ex_order_master = @ex_order_masters.last.external_order_no
      
      order_master_calculations.each do |orc|
        
        
        order_date = (orc.in_date).strftime("%Y-%m-%d") || "NA" if orc.in_date
        @num += 1
         employeeunorderlist << {
           :in_order_date => order_date,
           :order_date => orc.orderdate.strftime("%Y-%m-%d"),
           :channel => @channel,
           :prod1 => orc.prod1, :prod2 => orc.prod2,
           :order_no => orc.ordernum,
           :actual_date =>(orc.actual_order_date + 330.minutes).strftime("%Y-%m-%d %H:%M %P"),
           :order_ref => orc.order_ref,
           :order_status => orc.order_status,
           :payment_mode => orc.payment_mode}
      end
       #this is for date on the view
         @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
         @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
         @employeeorderlist = employeeunorderlist.sort_by{|c| c[:order_no]}
         
         flash[:success] = "We have the following details Channel: #{@channel}, From Date #{@from_date}, To Date #{@to_date} found #{order_master_calculations.count} records (Date field in_date)"
         
       respond_to do |format|
       csv_file_name = "channel_sales_#{@from_date}_#{@to_date}.csv"
         format.html
         format.csv do
           headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
           headers['Content-Type'] ||= 'text/csv'
         end
       end
  end
  
  def product_details
   
    @total_nos = 0
    @total_value = 0
    @sno = 1
          
     if params[:from_date].present?
       @or_for_date = params[:from_date]
       @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
       @to_date = @from_date
       if params.has_key?(:to_date)
         @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
       end
     end
     
     if params.has_key?(:prod)
       @prod =  params[:prod]
     end
     
     if (@prod == nil || @from_date == nil || @to_date == nil)
       flash[:success] = "No details found to show results"
       return
     end
     
     if ((@to_date - @from_date).to_i > 7 || (@to_date - @from_date).to_i < 0 )
       flash[:error] = "Choose a range between 7 days, this is CUSTDETAILS we are searching, currently you have searched for #{(@to_date - @from_date).to_i} days between #{@from_date} to #{@to_date}"
       return
     end
     
     
     @ex_from_date = @from_date.beginning_of_day - 330.minutes
     @ex_to_date = @to_date.end_of_day - 330.minutes
     
     @product_list_ids = ProductList.where(extproductcode: @prod).pluck(:id)
           
     if @product_list_ids.blank?
       flash[:success] = "No order details found when searching for product #{@prod} "
       return
     end
        
     order_master_calculations = CUSTDETAILS.where(:prod1.upcase => @prod.upcase)
     .where('TRUNC(in_date) >= ? AND TRUNC(in_date)<= ?', @from_date, @to_date)
     
     if order_master_calculations.blank?
       flash[:success] = "No order details found in CUSTDETAILS when searching for product #{@prod} between #{@from_date} to #{@to_date}"
       return
     end
     
     @custdetails_order = order_master_calculations.count
     @first_custdetails_order = order_master_calculations.first.ordernum if order_master_calculations
     @last_custdetails_order = order_master_calculations.last.ordernum if order_master_calculations
     
     @custdetails_order_list = order_master_calculations.pluck(:ordernum)
     
     # order_masters = OrderMaster.where('TRUNC(in_date) >= ? AND TRUNC(in_date)<= ?', @full_from_date, @full_to_date)
 #  
          
     
     
     @ex_order_masters = OrderMaster.where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @ex_from_date, @ex_to_date)
                         .where('ORDER_STATUS_MASTER_ID > 10000')
                         .joins(:order_line).where("order_lines.product_list_id in (?)", @product_list_ids)
                         .order(:external_order_no)
     
     if @ex_order_masters.blank?
       flash[:success] = "No orders found when searching for product #{@prod} between #{@from_date} to #{@to_date}"
       return
     end
     #@ex_new_orders = "Wow nothing missed"
     if @custdetails_order_list.count > 999
       flash[:error] = "OCIError: ORA-01795: maximum number of expressions in a list is 1000, means Oracle has limit of 1000 cross checks, this reports requires about #{@custdetails_order_list.count} records, you can reduce the date range."
       return
     end
     @ex_new_orders = @ex_order_masters.where.not(external_order_no: @custdetails_order_list).pluck(:external_order_no) 
     
     @missing_order_cross_check = CustomerOrderList.where(ordernum: @ex_new_orders)
     #.pluck(:id, :created_at, :ordernum, :order_ref)
     
     @ex_pay_u_money_order = @ex_order_masters.where(orderpaymentmode_id: 10080).where("order_status_master_id < 10003").count
     @ex_processed_orders = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).count(:external_order_no)
     @ex_cancelled_orders = @ex_order_masters.where(ORDER_STATUS_MASTER_ID: @cancelled_status_id).count(:external_order_no)
     @first_all_ex_order_master = @ex_order_masters.first.external_order_no
     @first_ex_order_master = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).first.external_order_no
     @last_ex_order_master = @ex_order_masters.where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).last.external_order_no
     @last_all_ex_order_master = @ex_order_masters.last.external_order_no
     
      
     employeeunorderlist ||= []
        @num = 0
        amount = 0
        # ("telephone like ? or dnis like ? ", "#{@telephone}%", "#{@telephone}%")
        
              
          order_master_calculations.each do |orc|
            actual_order_date = OrderMaster.find_by_external_order_no(orc.ordernum).orderdate || "Not found" if OrderMaster.find_by_external_order_no(orc.ordernum).present?
            @num += 1
            order_date = (orc.in_date).strftime("%Y-%m-%d") || "NA" if orc.in_date
            @num += 1
             employeeunorderlist << {
               :in_order_date => order_date,
               :order_date => orc.orderdate.strftime("%Y-%m-%d"),
               :channel => @channel,
               :prod1 => orc.prod1, :prod2 => orc.prod2,
               :order_no => orc.ordernum,
               :actual_date =>(actual_order_date + 330.minutes).strftime("%Y-%m-%d %H:%M %P"),
               :order_ref => OrderMaster.find_by_external_order_no(orc.ordernum).id,
               :order_status => "NA",
               :payment_mode => "NA"}
          end
       #this is for date on the view
         @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
         @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
         @employeeorderlist = employeeunorderlist
         
         flash[:success] = "We have the following details Product: #{@prod}, From Date #{@from_date}, To Date #{@to_date} found #{order_master_calculations.count} records"
         
       respond_to do |format|
       csv_file_name = "#{@prod}_sales_#{@from_date}_#{@to_date}.csv"
         format.html
         format.csv do
           headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
           headers['Content-Type'] ||= 'text/csv'
         end
       end
  end
  
  def between_date
   
    @total_nos = 0
    @total_value = 0
    @sno = 1
          
     if params[:from_date].present?
       @or_for_date = params[:from_date]
       @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
       @to_date = @from_date
       if params.has_key?(:to_date)
         @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
       end
     end
    
     
     if params.has_key?(:employee)
       @employee =  params[:employee].strip.upcase
     end
     
     if (@from_date == nil || @to_date == nil)
       flash[:success] = "No employee details found to show results, please enter employee details like CC Report"
       return
     end
     
     if ((@to_date - @from_date).to_i > 7 || (@to_date - @from_date).to_i < 0 )
       flash[:error] = "Choose a range between 7 days, this is CUSTDETAILS we are searching, currently you have searched for #{(@to_date - @from_date).to_i} days between #{@from_date} to #{@to_date}"
       return
     end
     
     @ex_from_date = @from_date.beginning_of_day - 330.minutes
     @ex_to_date = @to_date.end_of_day - 330.minutes
     
     if @employee.present?
       @employees = Employee.where("UPPER(first_name) like ?", "%#{@employee.upcase}%")
           #employee.name[0..49].upcase
     end
     if @employees.blank?
       flash[:info] = "No order details found when searching for employee #{@employee.upcase} "
      # return
     end
     
     employeeunorderlist ||= []
     @num = 0
     amount = 0
       
      begin
        # do something 
        order_master_calculations = CUSTDETAILS
        .where('TRUNC(orderdate) >= ? AND TRUNC(orderdate) <= ?', @from_date, @to_date)
        .order(:ordernum)
        
        if @employee.present?
          order_master_calculations = order_master_calculations.where("UPPER(username) like ?", "%#{@employee.upcase}%")
        end
      
      rescue ActiveRecord::RecordNotFound
        # handle not found error
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue ActiveRecord::ActiveRecordError
        # handle other ActiveRecord errors
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue # StandardError
        # handle most other errors
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      rescue Exception
        # handle everything else
        flash[:success] = "No details found to show results (Date field in_date) "
        return
      end
      
      if order_master_calculations.blank?
        flash[:success] = "No custdetails found when searching between #{@from_date} to #{@to_date}"
        return
      end
      
      
      
      order_master_calculations.each do |orc|
        
        
        order_date = (orc.in_date).strftime("%Y-%m-%d") || "NA" if orc.in_date
        @num += 1
         employeeunorderlist << {
           :in_order_date => order_date,
           :order_date => orc.orderdate.strftime("%Y-%m-%d"),
           :channel => @channel,
           :prod1 => orc.prod1, :prod2 => orc.prod2,
           :order_no => orc.ordernum,
           :actual_date =>(orc.actual_order_date + 330.minutes).strftime("%Y-%m-%d %H:%M %P"),
           :username => orc.username,
           :order_user => orc.order_user,
           :order_ref => orc.order_ref,
           :order_status => orc.order_status,
           :payment_mode => orc.payment_mode}
      end
       #this is for date on the view
         @from_date = (@from_date).strftime("%Y-%m-%d")
         @to_date = (@to_date).strftime("%Y-%m-%d")
         @employeeorderlist = employeeunorderlist.sort_by{|c| c[:order_no]}
         
         flash[:success] = "We have the following details Employee: #{@employee.upcase}, From Date #{@from_date}, To Date #{@to_date} found #{order_master_calculations.count} records (Date field orderdate NOT in_date)"
         
       respond_to do |format|
       csv_file_name = "channel_sales_#{@from_date}_#{@to_date}.csv"
         format.html
         format.csv do
           headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
           headers['Content-Type'] ||= 'text/csv'
         end
       end
  end
  
  private
  def all_cancelled_orders
    @cancelled_status_id = [10040, 10006, 10008]
    @cancelled_status_sql_list = '(10040, 10006, 10008)'
    #10040 => tranfer order cancelled
    #10006 => CFO and cancelled orders / unclaimed orders
    #10008 => Returned Order (post shipping)
    #session[:cancelled_status_id] = @cancelled_status_id
  end
end
