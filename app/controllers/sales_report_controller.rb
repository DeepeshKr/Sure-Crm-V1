class SalesReportController < ApplicationController
  before_action { protect_controllers(5) } 
   respond_to :html
  # before_filter :authenticate_user!
  def summary
        @sno = 1
        @datelist ||= []
        employeeunorderlist ||= []
        # if params[:for_date].present? 
        #   for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
        #   from_date = Date.current - 30.days
        #   to_date = Date.current
        # else
        #   from_date = Date.current - 30.days
        #   to_date = Date.current
        # end
        
          from_date = Date.current - 3.days #30.days
          to_date = Date.current
          to_date.downto(from_date).each do |day|
          @datelist <<  day.strftime('%d-%b-%y')
          web_date = day
          web_date = web_date.strftime()
          for_date = day # Date.
          @or_for_date = for_date
           
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date)
          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
          :for_date =>  web_date,
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
      @or_for_date = Date.strptime(params[:for_date], "%Y-%m-%d")
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []
    
        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes
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
          :start_time => halfhourago.strftime("%Y-%m-%d %H:%M"), :end_time => Time.at(date).strftime("%Y-%m-%d %H:%M"),
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
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      #media segregation
      hbnlist = Medium.where(media_group_id: 10000)
      paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000")
      others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000")


      hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: hbnlist).select(:media_id).distinct
      paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: paid).select(:media_id).distinct
      other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: others).select(:media_id).distinct

      total_hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: hbnlist)
      total_paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: paid)
      total_other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: others)
      
      @orderdate = "Orders for #{for_date}: #{total_hbn_order_masters.count} HBN Channel, #{total_paid_order_masters.count} Paid Channel and #{total_other_order_masters.count} Other Channel!"
      
      hbn_order_list ||= []
      num = 1
      hbn_order_masters.each do |o|
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
        hbn_order_list << {:total => totalorders,
           :id => e, :channel => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse 

        paid_order_list ||= []
        
        paid_order_masters.each do |o|
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
        paid_order_list << {:total => totalorders,
           :id => e, :channel => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @paid_order_list = paid_order_list.sort_by{|c| c[:total]}.reverse 
      
        other_order_list ||= []
       
        other_order_masters.each do |o|
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
        other_order_list << {:total => totalorders,
           :id => e, :channel => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @other_order_list = other_order_list.sort_by{|c| c[:total]}.reverse 
  


    end

  end

  def employee
      @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present?  
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
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
     showproducts
    
  end

  def show
    for_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
    end
    @orderdate = for_date
    @searchaction = 'show'
      #@for_date = @campaign.startdate
     @campaign_playlists =  CampaignPlaylist.joins(:campaign).where("campaigns.startdate = ?", for_date).order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
     
      hbnlist = Medium.where(media_group_id: 10000)
      paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000")
      others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000")


      hbn_order_masters = OrderMaster.joins(:medium).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: hbnlist)
    
      @hbn_ccvalue = hbn_order_masters.where(orderpaymentmode_id: 10000).sum(:total)
      @hbn_ccorders = hbn_order_masters.where(orderpaymentmode_id: 10000).count()
      @hbn_codorders = hbn_order_masters.where(orderpaymentmode_id: 10001).count()
      @hbn_codvalue = hbn_order_masters.where(orderpaymentmode_id: 10001).sum(:total)
      @hbn_totalorders = hbn_order_masters.sum(:total)
      @hbn_noorders = hbn_order_masters.count()

  
  end

  def orders
    @t = (330.minutes).from_now
    @sno = 1
    for_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end

    @orderlistabout = "for date #{for_date}"
    @order_masters =  OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002')
    
    if params.has_key?(:playlist_id)
     campaign_id =  params[:playlist_id]
     @order_masters = @order_masters.where('campaign_playlist_id = ?', campaign_id).order("orderdate")
      @orderlistabout = "for selected playlist #{for_date}"
    end
     
    if params.has_key?(:media)
      if params[:media] == 'hbn'
          hbnlist = Medium.where(media_group_id: 10000)
          @order_masters = @order_masters.where(media_id: hbnlist).order("orderdate")
          @orderlistabout = "for selected playlist HBN"
          if params.has_key?(:missed)
            @order_masters = @order_masters.where('campaign_playlist_id IS NULL').order("orderdate")
            @orderlistabout = "for selected playlist HBN Missed orders"
          end
      end
    end
    if params.has_key?(:start_time) && params.has_key?(:end_time)
      start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
      end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 
     
     
     @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
     @orderlistabout = "for selected playlist #{for_date} between #{start_time} and #{end_time} "
    end
    

  
  end #end of def  

 

 private

 def shows_between
    for_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end

    if params.has_key?(:start_time) && params.has_key?(:end_time)
      start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
      end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

       @campaign_playlists =  CampaignPlaylist.joins(:campaign).where('campaigns.startdate = ?', for_date)
       .where("start_hr >= ? and start_min >= ? and end_hr <= ? end_min <= ?", start_time.hour, start_time.min, end_time.hour, end_time.min)
       .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
     
      if start_time.hour < 2
        #show previous day shows as well
        previous_start_hr = 22
        previous_start_min = 0 
        previous_end_hr = 23
        previous_end_min = 59
        previous_day = for_date - 1.day
        @campaign_playlists =  CampaignPlaylist.joins(:campaign).where('campaigns.startdate = ?', previous_day)
        .where("start_hr >= ? and start_min >= ? and end_hr <= ? end_min <= ?", previous_start_hr, previous_start_min, previous_end_hour, previous_end_min)
        .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)   
      end
     

    end
   
 end

 def showproducts
   #@summary ||= []
   if params[:for_date].present? 
     
   
      @or_for_date = params[:for_date]
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
       @orderdate = params[:for_date]

      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
      order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
      order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
      
       if params.has_key?(:start_time) && params.has_key?(:end_time)
        start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 
        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
        order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
        order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).distinct
       end

      regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
      common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
      basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)

      reg_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: regular_product_variant_list).select(:product_list_id).distinct
      common_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: common_sell_product_variant_list).select(:product_list_id).distinct
      basic_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: basic_sell_product_variant_list).select(:product_list_id).distinct
      
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
        main_product_list_orderlist ||= []
        num = 1
        reg_order_lines.each do |o|
        e = o.product_list_id
       
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        main_product_list_orderlist << {:total => totalorders,
           :id => e, :product => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse 

        common_product_list_orderlist ||= []
        common_order_lines.each do |o|
        e = o.product_list_id
       
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        common_product_list_orderlist << {:total => totalorders,
           :id => e, :product => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse 


       basic_product_list_orderlist ||= []
        basic_order_lines.each do |o|
        e = o.product_list_id
       
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        basic_product_list_orderlist << {:total => totalorders,
           :id => e, :product => name, :for_date =>  @or_for_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse  
     end
 end
end
