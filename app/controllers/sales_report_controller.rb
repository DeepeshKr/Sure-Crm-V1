class SalesReportController < ApplicationController
   respond_to :html
  def summary
        @sno = 1
        @datelist ||= []
        employeeunorderlist ||= []
        from_date = Date.current - 10.days
        to_date = Date.current

        to_date.downto(from_date).each do |day|
          @datelist <<  day.strftime('%d-%b-%y')
      
          for_date = day # Date.strptime(day, "%m/%d/%Y")
          @or_for_date = for_date
           
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date)
          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
          :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 

  end

  def hourly
    #/sales_report/hourly?for_date=05%2F09%2F2015
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"  
    @sno = 1
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
    
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []
    
        from_date = for_date.beginning_of_day
        to_date = for_date.end_of_day
        #start loop
        
        (from_date.to_datetime.to_i .. to_date.to_datetime.to_i).step(30.minutes) do |date|
         
         halfhourago = Time.at(date - 30.minutes) 

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
          :starttime =>  halfhourago.strftime("%d-%b %H:%M %p"),
          :endtime => Time.at(date).strftime("%d-%b %H:%M %p"),
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
       @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
     end
      
  end

  def daily

       @datelist ||= []
       from_date = Date.current - 10.days
      (from_date..to_date).each do |day|
        @datelist <<  day.strftime('%d-%b-%y')
      end

      @sno = 1
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:employee_id).distinct
      
      @orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id
       
        name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date).where(employee_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :employee => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse 
  

    end
  end

  def channel
    #/sales_report/channel?for_date=05%2F09%2F2015
     @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:media_id).distinct
      
      @orderdate = "Searched for #{for_date} found #{order_masters.count} Channel with orders!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.media_id
       
        name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date).where(media_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :channel => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse 
  

    end

  end

  def employee
      @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:employee_id).distinct
      
      @orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id
       
        name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date).where(employee_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :employee => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse 
  

    end
  end

  def product
     @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      order_masters = OrderLine.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:employee_id).distinct
      
      @orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id
       
        name = (ProductMaster.find(e).name  || "NA" if ProductMaster.find(e).name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date).where(employee_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :product => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse 
  
  end

  def show
  end
end
