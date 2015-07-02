class SalesReportController < ApplicationController
  before_action { protect_controllers(7) } 
   respond_to :html
  # before_filter :authenticate_user!
  def summary
        @sno = 1
        @datelist ||= []
        employeeunorderlist ||= []
       
         #media segregation only HBN
          media_segments

          from_date = Date.current - 30.days #30.days
          to_date = Date.current
          to_date.downto(from_date).each do |day|
          @datelist <<  day.strftime('%d-%b-%y')
          web_date = day
          web_date = web_date.strftime()
          for_date = day # Date.
          @or_for_date = for_date
           
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('TRUNC(orderdate) = ?',for_date)
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
        # flash[:notice] = "remove restrictions of 10"
  end
   def daily

       @datelist ||= []
       from_date = Date.current - 30.days
      (from_date..to_date).each do |day|
        @datelist <<  day.strftime('%d-%b-%y')
      end

      #media segregation only HBN
      media_segments

      @sno = 1
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:employee_id).distinct
      
      @orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id
       
        name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('TRUNC(orderdate) = ?',for_date).where(media_id: @hbnlist).where(employee_id: e)
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
        #media segregation only HBN
        media_segments

        #start loop
        
        (from_date.to_datetime.to_i .. to_date.to_datetime.to_i).step(30.minutes) do |date|
         
         halfhourago = Time.at(date - 30.minutes) 

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
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
      media_segments

      hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:media_id).distinct
      paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @paid).select(:media_id).distinct
      other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @others).select(:media_id).distinct

      total_hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist)
      total_paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @paid)
      total_other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @others)
      

      @orderdate = "Orders for #{for_date}: HBN Channel #{total_hbn_order_masters.count} for Rs. #{total_hbn_order_masters.sum(:total)}, Paid channels #{total_paid_order_masters.count} for Rs. #{total_paid_order_masters.sum(:total)} and Free Channel #{total_other_order_masters.count} for Rs. #{total_other_order_masters.sum(:total)}!"
      
      hbn_order_list ||= []
      num = 1
        #hbn channels
        hbn_order_masters.each do |o|
        e = o.media_id
       
        name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)

        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('TRUNC(orderdate) = ?',for_date).where(media_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count(:id)
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
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('TRUNC(orderdate) = ?',for_date).where(media_id: e)
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
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('TRUNC(orderdate) = ?',for_date).where(employee_id: e)
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

   def city
      @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present?  
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
       
      if params.has_key?(:media_id)
         order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date)
         .where(media_id: params[:media_id])
      .where('ORDER_STATUS_MASTER_ID > 10002').where('customer_address_id IS NOT NULL')
      .joins(:customer_address).select("customer_addresses.city").distinct

        from_channel = Medium.find(params[:media_id]).name
      else
         order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date)
      .where('ORDER_STATUS_MASTER_ID > 10002').where('customer_address_id IS NOT NULL')
      .joins(:customer_address).select("customer_addresses.city").distinct
       end

      @orderdate = "Searched for #{for_date} #{from_channel} found #{order_masters.count} cities!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        city = o.city
          if city.present?
            #city = CustomerAddress.find(e).city  #  || "NA" if Employee.find(e).first_name.present?)
            
            orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
            .where('TRUNC(orderdate) = ?',for_date).joins(:customer_address)
            .where("customer_addresses.city = ?", city)
             if params.has_key?(:media_id)
              orderlist = orderlist.where(media_id: params[:media_id])
             end
            timetaken = orderlist.sum(:codcharges)
            ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
            ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
            codorders = orderlist.where(orderpaymentmode_id: 10001).count()
            codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            employeeunorderlist << {:total => totalorders,
                :employee => city, :for_date =>  @or_for_date,
              :nos => noorders, :codorders => codorders, :codvalue => codvalue,
               :ccorders => ccorders, :ccvalue => ccvalue  }

          end
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
     
     media_segments

      hbn_order_masters = OrderMaster.joins(:medium).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist)
    
      @hbn_ccvalue = hbn_order_masters.where(orderpaymentmode_id: 10000).sum(:total)
      @hbn_ccorders = hbn_order_masters.where(orderpaymentmode_id: 10000).count()
      @hbn_codorders = hbn_order_masters.where(orderpaymentmode_id: 10001).count()
      @hbn_codvalue = hbn_order_masters.where(orderpaymentmode_id: 10001).sum(:total)
      @hbn_totalorders = hbn_order_masters.sum(:total)
      @hbn_noorders = hbn_order_masters.count()

  
  end

  def order_summary
    #aggregation based on products 
   @sno = 1
    showproducts
    shows_between
   
  end #end of def  

  def orderlisting
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
          @order_masters = @order_masters.where(media_id: @hbnlist).order("orderdate")
          @orderlistabout = "for selected playlist HBN"
          if params.has_key?(:missed)
            @order_masters = @order_masters.where('campaign_playlist_id IS NULL')
            .order("orderdate")
            @orderlistabout = "for selected playlist HBN Missed orders"
          end
      end
    end
    if params.has_key?(:employee_id).present?
      @employee_id = params[:employee_id]
      employee = Employee.find(@employee_id).fullname
      if params[:completed].present?
        # all completed orders only
         if params[:for_date].present? 
          for_date =  Date.strptime(params[:for_date], "%m-%d-%Y")

          @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('TRUNC(orderdate) = ?',for_date)
          .where(employee_id: @employee_id).order("id")
          @orderdesc = "#{@order_masters.count()} orders of #{employee} for #{for_date}"

         end
      else
         @orderdesc = "Recent 1000 all orders of #{employee} "
          @order_masters = OrderMaster.where(employee_id: @employee_id).order("id DESC").limit(1000)
      end

    end

    if params.has_key?(:start_time) && params.has_key?(:end_time)
      start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
      end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 
     
     
     @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
     .where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
     @orderlistabout = "for selected playlist #{for_date} between #{start_time} and #{end_time} "
    end
    

  
  end #end of def  
  

 private

 def shows_between
    for_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end

    #media segregation only HBN
    media_segments

    @show_date = for_date.strftime("%d-%b-%Y")

    if params.has_key?(:start_time) && params.has_key?(:end_time)
      
       @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        
        if @start_time.hour < 4
        #show previous day shows as well
        previous_start_hr = 20
        case @start_time.hour # a_variable is the variable we want to compare
          when 3   #compare to 1
            previous_start_hr = 23
          when 2    #compare to 2
           previous_start_hr = 22
          when 1
           previous_start_hr = 21
          end
        
        
        previous_startsecs = (previous_start_hr * 60 * 60) 
        previous_endsecs = (23 * 60 * 60) + (59 * 60)
        previous_day = for_date - 1.day

        @earlier_day = previous_day.strftime("%d-%b-%Y")

        @old_campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (end_hr * 60 *60 )  + (end_min *60) <= ?", previous_startsecs, previous_endsecs)
       .joins(:campaign).where("campaigns.startdate = ?", previous_day)
       .where('campaigns.mediumid IN (?)', @hbnlist)
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
        
        else
        @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        @start_time = @start_time - 4.hours
        @end_time = @end_time 
        end
     

      @Show_start_time = @start_time.strftime("%H:%M")
      @Show_end_time = @end_time.strftime("%H:%M")

      # @campaign_playlists =  CampaignPlaylist.where(list_status_id: 10000).limit(10)
      startsecs = (@start_time.hour * 60 * 60) + (@start_time.min * 60)
      endsecs = (@end_time.hour * 60 * 60) + (@end_time.min * 60) + (15 * 60)

       @campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (end_hr * 60 *60 )  + (end_min *60) <= ?", startsecs, endsecs)
       .joins(:campaign).where("campaigns.startdate = ?", for_date)
       .where('campaigns.mediumid IN (?)', @hbnlist)
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
     
      

    end
   
 end

 def showproducts
   #@summary ||= []
   if params[:for_date].present? 
     
   
      @or_for_date = params[:for_date]
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
       @orderdate = params[:for_date]

       @show_date = for_date

      #media segregation only HBN
      media_segments

      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:id).where(media_id: @hbnlist).distinct
      order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
      order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
      
       if params.has_key?(:start_time) && params.has_key?(:end_time)
        start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        @Show_start_time = start_time.strftime("%H:%M")
        @Show_end_time = end_time.strftime("%H:%M")


        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
        order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
        order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
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


 def media_segments
  @hbnlist = Medium.where(media_group_id: 10000).pluck(:id)
  @paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000").select("id")
  @others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000").select("id")

 end
end
