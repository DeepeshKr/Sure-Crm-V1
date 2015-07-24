class SalesPpoReportController < ApplicationController
  before_action { protect_controllers(4) } 
  before_action :media_segments, only: [:daily, :hourly, :show, :channel]
  def summary
     @sno = 1
     @searchaction = "summary"
        @datelist ||= []
        employeeunorderlist ||= []

      #  @or_for_date = Date.strptime(params[:for_date], "%d-%m-%Y")
      #for_date =  Date.strptime(params[:for_date], "%d-%m-%Y")
     
         #media segregation only HBN
          media_segments
          use_date = (330.minutes).from_now.to_date
          from_date = use_date.to_date - 2.days #30.days
          up_to_date = use_date.to_date

          # from_date = (330.minutes).from_date.to_date
          # up_to_date = (330.minutes).up_to_date.to_date

          up_to_date.downto(from_date).each do |day|
          @datelist <<  day.strftime('%y-%b-%d')
          web_date = day
          web_date = web_date.strftime()
          for_date = day # Date.
          @or_for_date = for_date
           
           orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
           .where('TRUNC(orderdate) = ?',for_date).where(media_id: @hbnlist)

          # #split the fixed cost across the hour
          revenue = 0
          media_var_cost = 0
          product_cost = 0

          orderlist.each do |med |
            #error loggin
            begin
                        
            revenue += OrderMaster.find(med.id).productrevenue ||= 0
           # media_var_cost += OrderMaster.find(med.id).mediacost ||= 0
            product_cost += OrderMaster.find(med.id).productcost ||= 0
            media_variable = Medium.where('id = ? AND value is not null', med.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                correction = 0.5
                #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
               media_var_cost += (med.subtotal * media_variable.first.value.to_f) * correction
              end
               rescue => e
               logger.warn "Unable to foo, will ignore: #{e}" 
            end
          end
          fixed_cost = Medium.where(media_group_id: 10000).sum(:daily_charges)
          
          #ppo for each hour
         
           totalorders = orderlist.sum(:total)
          nos = orderlist.count()
          pieces = orderlist.sum(:pieces)
          employeeunorderlist << {:total => totalorders,
          :for_date =>  for_date.strftime("%Y-%m-%d"),
          :pieces => pieces,
          :nos => nos,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => (revenue - (product_cost + fixed_cost + media_var_cost)).to_i }
        end
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
  end

  def daily
      @datelist ||= []
       from_date = Date.current - 30.days
      (from_date..to_date).each do |day|
        @datelist <<  day.strftime('%d-%b-%y')
      end

    @sno = 1
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where(media_id: @hbnlist).select(:employee_id).distinct
      
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
    #@searchaction = "hourly"
     #/sales_report/hourly?for_date=05%2F09%2F2015
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"  
    @sno = 1
    @searchaction = "hourly"
   for_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
     @or_for_date = Date.strptime(params[:for_date], "%Y-%m-%d")
    #for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end
      #@summary ||= []
      
      
        @total_nos = 0
        @total_pieces = 0
        @total_var_cost = 0
         @total_fixed_cost = 0
         @total_cost = 0
         @total_sales = 0
         @total_profit = 0
          @total_revenue = 0
          @total_product_cost = 0
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []
    
        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN
        

        #start loop
        
        (from_date.to_datetime.to_i .. to_date.to_datetime.to_i).step(30.minutes) do |date|
         
         halfhourago = Time.at(date - 30.minutes) 
        
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where(media_id: @hbnlist)
          .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          #add orders of each cable tv operator

          #split the fixed cost across the hour
           revenue = 0
            media_var_cost = 0
             product_cost = 0

          orderlist.each do |med |
            revenue += OrderMaster.find(med.id).productrevenue ||= 0
           # media_var_cost += OrderMaster.find(med.id).mediacost ||= 0
            product_cost += OrderMaster.find(med.id).productcost ||= 0
            media_variable = Medium.where('id = ? AND value is not null', med.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                correction = 0.5
                #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
               media_var_cost += (med.subtotal * media_variable.first.value.to_f) * correction
              end
          end
         
         
        #   params.require(:media_cost_master).permit(:name, :duration_secs, 
        # :total_cost, :media_id, :str_hr, :str_min,
        #  :str_sec, :end_hr, :end_min, :end_sec, 
        #  :description, :slot_percent)
          
          total_cost = Medium.where(media_group_id: 10000).sum(:daily_charges)

          start_hr = halfhourago.strftime("%H")
          start_min = halfhourago.strftime("%M")
          end_hr = Time.at(date).strftime("%H")
          end_min = Time.at(date).strftime("%M")
          media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
          fixed_cost = media_cost_master.first.total_cost
          #ppo for each hour
          nos = orderlist.count()
          pieces = orderlist.sum(:pieces)
          totalorders = orderlist.sum(:total)
         
          employeeunorderlist << {:total => totalorders,
          :starttime =>  halfhourago.strftime("%H:%M %p"),
          :endtime => Time.at(date).strftime("%H:%M %p"),
          :start_time => halfhourago.strftime("%Y-%m-%d %H:%M"), 
          :end_time => Time.at(date).strftime("%Y-%m-%d %H:%M"),
          :pieces => pieces,
          :nos => nos,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => (revenue - (fixed_cost + media_var_cost + product_cost)).to_i }
        end
       @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
   
  end

  def show
    #add this link to show
    #<%= link_to "View PPO", ppo_details_path(campaign_id: c[:campaign_id]), :target => "_blank" %>
    @searchaction = "show"
    for_date = (330.minutes).from_now.to_date

    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end
    @sno = 1
    @or_for_date = for_date
    @total_nos = 0
      @total_pieces = 0
        @total_var_cost = 0
        @total_fixed_cost = 0
        @total_cost = 0
        @total_sales = 0
        @total_profit = 0
        @total_revenue = 0
        @total_product_cost = 0
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []

    @orderdate = for_date
    @searchaction = 'show'
      #@for_date = @campaign.startdate
     campaign_playlists =  CampaignPlaylist.joins(:campaign)
     .where("campaigns.startdate = ?", for_date)
     .order(:start_hr, :start_min, :start_sec)
     .where(list_status_id: 10000) #.limit(10)
     
          total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
          secs_in_a_day = (24*60*60) 
          media_cost = total_media_cost / secs_in_a_day

     campaign_playlists.each do | playlist |
     orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
     .where(campaign_playlist_id: playlist.id)


      
          #add orders of each cable tv operator

          #split the fixed cost across the hour
           revenue = 0
            media_var_cost = 0
             product_cost = 0

          orderlist.each do |med |
            revenue += OrderMaster.find(med.id).productrevenue ||= 0
             # media_var_cost += OrderMaster.find(med.id).mediacost ||= 0
            product_cost += OrderMaster.find(med.id).productcost ||= 0
            media_variable = Medium.where('id = ? AND value is not null', med.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                correction = 0.5
                #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
               media_var_cost += (med.subtotal * media_variable.first.value.to_f) * correction
              end
          end
          total_seconds = totalseconds(playlist.id).to_f
         fixed_cost =  media_cost * total_seconds
          totalorders = orderlist.sum(:total)
           nos = orderlist.count()
         pieces = orderlist.sum(:pieces)
          employeeunorderlist << {:show =>  playlist.product_variant.name,
          :campaign_id => playlist.id,
           :pieces => pieces,
          :nos => nos,
          :at_time => playlist.starttime,
          :total => totalorders,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => (revenue - (fixed_cost + media_var_cost + product_cost)).to_i ,
          :product_variant_id => playlist.productvariantid}
        end
        @employeeorderlist = employeeunorderlist

   
  end

  def ppo_details
   
    #aggregation based on products 
    @sno = 1
    @time_sno = 1
    showproducts
    shows_between
    
    between_time #show between timings

    hbn_channels_between #channel between timings
  end #end of def  
    

  def channel
     #/sales_report/channel?for_date=05%2F09%2F2015
     @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present? 
      #@summary ||= []
      @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
     

      hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:media_id).distinct
      paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @paid).select(:media_id).distinct
      other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @others).select(:media_id).distinct

      total_hbn_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist)
      total_paid_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @paid)
      total_other_order_masters = OrderMaster.where('TRUNC(orderdate) = ?',for_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @others)
      

      @orderdate = "Orders for #{for_date}: HBN Channel #{total_hbn_order_masters.count} for Rs. #{total_hbn_order_masters.sum(:total)}, Paid channels #{total_paid_order_masters.count} for Rs. #{total_paid_order_masters.sum(:total)} and Free Channel #{total_other_order_masters.count} for Rs. #{total_other_order_masters.sum(:total)}!"
      
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
           :ccorders => ccorders, :ccvalue => ccvalue,
            :product_variant_id => o.productvariant_id}
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
           :ccorders => ccorders, :ccvalue => ccvalue,
            :product_variant_id => o.productvariant_id}
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
           :ccorders => ccorders, :ccvalue => ccvalue,
            :product_variant_id => o.productvariant_id}
        end
        @other_order_list = other_order_list.sort_by{|c| c[:total]}.reverse 
  end


   

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
            @order_masters = @order_masters.where('campaign_playlist_id IS NULL').order("orderdate")
            @orderlistabout = "for selected playlist HBN Missed orders"
          end
      end
    end
    if params.has_key?(:start_time) && params.has_key?(:end_time)
      @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
      @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 
     
      @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
      @orderlistabout = "for selected playlist #{for_date} between #{start_time} and #{end_time} "
    end
    
  end
  
end #end of def  

private
def totalseconds(playlist_group_id)
totalsecs = 0
  all_grp_playlists = CampaignPlaylist.where(playlist_group_id: playlist_group_id)

    all_grp_playlists.each  do | grp|
      totalsecs += grp.duration_secs.to_i
    end
return totalsecs
end

 def between_time
           
    if params.has_key?(:start_time) & params.has_key?(:end_time)

      @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

      #@summary ||= []
      @or_for_date = Date.strptime(params[:for_date], "%Y-%m-%d")
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      
        @total_nos = 0
        @total_var_cost = 0
        @total_fixed_cost = 0
        @total_sales = 0
        @total_profit = 0
        @total_revenue = 0
        #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []
    
        from_date = @start_time + 1.minutes
        to_date = @end_time #- 330.minutes
        #media segregation only HBN
        
        # @start_time = @start_time.strftime("%Y-%m-%d %H:%M")
        # @end_time = @@end_time.strftime("%Y-%m-%d %H:%M")
        #start loop
        
        (from_date.to_datetime.to_i .. to_date.to_datetime.to_i).step(1.minutes) do |date|
         
         halfhourago = Time.at(date - 1.minutes) 
        
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where(media_id: @hbnlist)
          .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          #add orders of each cable tv operator

          #split the fixed cost across the hour
           revenue = 0
            media_var_cost = 0
             product_cost = 0

          orderlist.each do |med |
            revenue += OrderMaster.find(med.id).productrevenue ||= 0
           # media_var_cost += OrderMaster.find(med.id).mediacost ||= 0
            product_cost += OrderMaster.find(med.id).productcost ||= 0
            media_variable = Medium.where('id = ? AND value is not null', med.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                correction = 0.5
                #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
               media_var_cost += (med.subtotal * media_variable.first.value.to_f) * correction
              end
          end
         
         
        #   params.require(:media_cost_master).permit(:name, :duration_secs, 
        # :total_cost, :media_id, :str_hr, :str_min,
        #  :str_sec, :end_hr, :end_min, :end_sec, 
        #  :description, :slot_percent)

          diff = 1 #start_time - end_time
          divided =  (24 * 60) / diff
          fixed_cost = Medium.where(media_group_id: 10000).sum(:daily_charges)
          fixed_cost = fixed_cost / divided
          #ppo for each hour
         
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
          :starttime =>  halfhourago.strftime("%H:%M %p"),
          :endtime => Time.at(date).strftime("%H:%M %p"),
          :start_time => halfhourago.strftime("%Y-%m-%d %H:%M"), 
          :end_time => Time.at(date).strftime("%Y-%m-%d %H:%M"),
          :nos => noorders,
          :revenue => revenue,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => revenue - (fixed_cost + media_var_cost) }
        end
       @timelist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
     end
  end

def hbn_channels_between
   #media segregation only HBN
    media_segments
    value_now = 0
   correction = 0.5
   timetaken = 0
    if params.has_key?(:start_time) && params.has_key?(:end_time)
      #  @or_for_date = params[:for_date]
      # for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        
        hbn_order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
        .where(media_id: @hbnlist).select(:media_id).distinct

         hbn_order_list ||= []

       hbn_order_masters.each do |o|
        e = o.media_id
       
        name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
          .where(media_id: e)

           orderlist.each {|ol| timetaken += ol.timetaken  }
       
         media_variable = Medium.where('id = ? AND value is not null', o.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                 #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
                 value_now = media_variable.first.value
                                
              end
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        hbn_order_list << {:total => totalorders,
           :id => e, :channel => name, :for_date =>  @or_for_date,
          :nos => noorders, :correction => correction,
          :commission => value_now }
        end
        @hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse 

      elsif params.has_key?(:for_date) && params.has_key?(:product_variant)
        ###########################
        #for a particular show only
        #############
        @hbn_order_masters = OrderLine.joins(:order_master)
        .where('ordermasters.orderdate >= ?', params[:for_date])
        .where('ordermasters.ORDER_STATUS_MASTER_ID > 10002')
        .where("ordermasters.media_id in [@hbnlist]")
        .where(productvariant_id: params[:product_variant])
        .select("ordermasters.media_id").distinct

        # hbn_order_masters = OrderMaster.
        #     .where(id: order_with_product_variants)
        # .select(:media_id).distinct

         hbn_order_list ||= []

       # @hbn_order_masters.each do |o|
       #  e = o.media_id
       
       #  name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
       #  orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
       #    .where('orderdate >= ?', params[:for_date])
       #    .where(media_id: e)
       #  timetaken = orderlist.sum(:codcharges)
        
       #   media_variable = Medium.where('id = ? AND value is not null', o.media_id)
       #      .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
       #        if media_variable.present?
       #          #discount the total value by 50% as correction
       #           #PAID_CORRECTION
       #           if media_variable.first.paid_correction.present?
       #             correction = media_variable.first.paid_correction #||= 0.5
       #           end
       #           value_now = media_variable.first.value
                                
       #        end
       #  totalorders = orderlist.sum(:total)
       #  noorders = orderlist.count()
       #  hbn_order_list << {:total => totalorders,
       #     :id => e, :channel => name, :for_date =>  @or_for_date,
       #    :nos => noorders, :correction => correction,
       #    :commission => value_now }
       #  end
        #@hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse 

       
    end


end

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

        @old_campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (start_hr * 60 *60 )  + (start_min *60) <= ?", previous_startsecs, previous_endsecs)
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
      startsecs = ((@start_time.hour) || 0 * 60 * 60) + ((@start_time.min) || 0 * 60)
      endsecs = (@end_time.hour * 60 * 60) + (@end_time.min * 60) 

       @campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (start_hr * 60 *60 )  + (start_min *60) <= ?", startsecs, endsecs)
       .joins(:campaign).where("campaigns.startdate = ?", for_date)
       .where('campaigns.mediumid IN (?)', @hbnlist)
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
     
      elsif params.has_key?(:product_variant)

        @campaign_playlists =  CampaignPlaylist.joins(:campaign).where("campaigns.startdate = ?", for_date)
       .where(productvariantid: params[:product_variant])
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
      

    end
   
 end

 def showproducts
   #@summary ||= []
   if params[:for_date].present? 
     
    ccvalue = 0
    ccorders = 0
    codorders = 0
    codvalue = 0

    product_revenue = 0
    product_cost = 0

    revenue_of_product = 0
    cost_of_product = 0

    @total_orders_sales = 0
    @total_orders_nos = 0
    @total_orders_revenue = 0
    @total_Orders_product_cost = 0
    @actual_media_cost = 0
    @order_media_var_cost = 0
    @total_order_profitability = 0

    @main_total_orders_subtotal = 0
        @main_total_orders_shipping = 0
        @main_total_orders_total = 0
        @main_total_orders_nos = 0
        @main_total_orders_revenue = 0
        @main_total_Orders_product_cost = 0

      @common_total_orders_subtotal = 0
        @common_total_orders_shipping = 0
        @common_total_orders_total = 0
        @common_total_orders_nos = 0
        @common_total_orders_revenue = 0
        @common_total_Orders_product_cost = 0

      @basic_total_orders_subtotal = 0
        @basic_total_orders_shipping = 0
        @basic_total_orders_total = 0
        @basic_total_orders_nos = 0
        @basic_total_orders_revenue = 0
        @basic_total_Orders_product_cost = 0

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

        start_hr = start_time.hour
        start_min = start_time.min
        end_hr = end_time.hour
        end_min = end_time.min

        media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)

        @actual_media_cost = media_cost_master.first.total_cost

        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
        order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
       order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
       

        order_master_list = OrderMaster.where(id: order_masters)
          #split the fixed cost across the hour 
         
          @order_media_var_cost_full = 0
          order_master_list.each do |med |
           
            media_variable = Medium.where('id = ? AND value is not null', med.media_id)
            .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
              if media_variable.present?
                #discount the total value by 50% as correction
                correction = 0.5
                #PAID_CORRECTION
                 if media_variable.first.paid_correction.present?
                   correction = media_variable.first.paid_correction #||= 0.5
                 end
               @order_media_var_cost_full += (med.subtotal * media_variable.first.value.to_f)   
               @order_media_var_cost += (med.subtotal * media_variable.first.value.to_f) * correction
              end
          end

       end

            
      if params.has_key?(:product_variant)
        regular_product_variant_list = ProductVariant.where(id: params[:product_variant])
        #common_sell_product_variant_list = ProductVariant.find(params[:product_variant])
        #basic_sell_product_variant_list =  ProductVariant.find(params[:product_variant])

      else
        regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
        common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
        basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)

      end

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

        revenue_of_product = 0
        cost_of_product = 0

        prod = ProductList.find(e).extproductcode
        if prod.present?
            ropmaster  = ROPMASTER_NEW.where("prod = ?", prod).first
            if ropmaster.present?
              revenue_of_product = ropmaster.totalrevenue
              cost_of_product =ropmaster.totalcost
            end
        end

        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
       
         #orderlist.each {|ol| product_cost += o.productcost  }
         #orderlist.each {|ol| product_revenue += o.productrevenue  }
          subtotal = orderlist.sum(:subtotal)
           shipping = orderlist.sum(:shipping)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        main_product_list_orderlist << {:total => totalorders, :nos => noorders,
          :cost_of_product => cost_of_product, :revenue_of_product => revenue_of_product,
           :id => e, :product => name, :for_date =>  @or_for_date,
             :prod => prod,
           :subtotal => subtotal, :shipping => shipping,
          :product_cost => cost_of_product  * noorders, :product_revenue => revenue_of_product * noorders,
           :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }

        @main_total_orders_subtotal += subtotal
        @main_total_orders_shipping += shipping
        @main_total_orders_total += totalorders
        @main_total_orders_nos += noorders
        @main_total_orders_revenue += revenue_of_product * noorders
        @main_total_Orders_product_cost += cost_of_product  * noorders


        @total_orders_sales += totalorders
        @total_orders_nos += noorders
        @total_orders_revenue += revenue_of_product * noorders
        @total_Orders_product_cost += cost_of_product  * noorders
        end

       

        product_revenue = 0
        product_cost = 0
        
        @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse 

        common_product_list_orderlist ||= []
        common_order_lines.each do |o|
        e = o.product_list_id
        
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
        timetaken = orderlist.sum(:codcharges)
        #product_revenue = orderlist.sum(:productrevenue)
        #product_cost = orderlist.sum(:productcost)
        revenue_of_product = 0
        cost_of_product = 0

        prod = ProductList.find(e).extproductcode
        if prod.present?
            ropmaster  = ROPMASTER_NEW.where("prod = ?", prod).first
            if ropmaster.present?
              revenue_of_product = ropmaster.totalrevenue
              cost_of_product =ropmaster.totalcost
            end
        end
       

        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
       
         orderlist.each {|ol| product_cost += ol.productcost  }
         orderlist.each {|ol| product_revenue += ol.productrevenue  }

          subtotal = orderlist.sum(:subtotal)
           shipping = orderlist.sum(:shipping)
        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        common_product_list_orderlist << {:total => totalorders,
           :cost_of_product => cost_of_product, :revenue_of_product => revenue_of_product,
               :subtotal => subtotal, :shipping => shipping,
                 :prod => prod,
           :id => e, :product => name, :for_date =>  @or_for_date,
           :product_cost => cost_of_product  * noorders,
            :product_revenue => revenue_of_product * noorders,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        
        @common_total_orders_subtotal += subtotal
        @common_total_orders_shipping += shipping
        @common_total_orders_total += totalorders
        @common_total_orders_nos += noorders
        @common_total_orders_revenue += revenue_of_product * noorders
        @common_total_Orders_product_cost += cost_of_product  * noorders

        @total_orders_sales += totalorders
        @total_orders_nos += noorders
        @total_orders_revenue += revenue_of_product * noorders
        @total_Orders_product_cost += cost_of_product  * noorders
        end


        @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse 
        
        product_revenue = 0
        product_cost = 0

        basic_product_list_orderlist ||= []
        basic_order_lines.each do |o|
        e = o.product_list_id
        
        revenue_of_product = 0
        cost_of_product = 0
        prod = (ProductList.find(e).extproductcode)
        if prod.present?
            ropmaster  = ROPMASTER_NEW.where("prod = ?", prod).first
            if ropmaster.present?
              revenue_of_product = ropmaster.totalrevenue
              cost_of_product =ropmaster.totalcost
            end
        end

        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
        timetaken = orderlist.sum(:codcharges)
        ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
        ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
        codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
        codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
        
         #orderlist.each {|ol| product_cost += ol.productcost  }
         #orderlist.each {|ol| product_revenue += ol.productrevenue  }

          subtotal = orderlist.sum(:subtotal)
           shipping = orderlist.sum(:shipping)
        totalorders = orderlist.sum(:total)



        orderlist.each {|ol| product_cost += ol.productcost  }

        noorders = orderlist.count()
        basic_product_list_orderlist << {:total => totalorders,
              :subtotal => subtotal, :shipping => shipping,
              :prod => prod,
           :cost_of_product => cost_of_product, :revenue_of_product => revenue_of_product,
           :id => e, :product => name, :for_date =>  @or_for_date,
            :product_cost => cost_of_product  * noorders, :product_revenue => revenue_of_product * noorders,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        
        @basic_total_orders_subtotal += subtotal
        @basic_total_orders_shipping += shipping
        @basic_total_orders_total += totalorders
        @basic_total_orders_nos += noorders
        @basic_total_orders_revenue += revenue_of_product * noorders
        @basic_total_Orders_product_cost += cost_of_product  * noorders

        @total_orders_sales += totalorders
        @total_orders_refund = @total_orders_sales * 0.02
        @total_orders_nos += noorders
        @total_orders_revenue += revenue_of_product * noorders
        @total_Orders_product_cost += cost_of_product  * noorders
        end

        @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse  
        
        @total_order_profitability = @total_orders_revenue + (@total_Orders_product_cost + @actual_media_cost + @order_media_var_cost)
        #60%
        total_Orders_product_cost_60 = 0
        @total_orders_sales_60 = (@total_orders_sales * 0.6) || 0
        @total_orders_nos_60 = (@total_orders_nos * 0.6) || 0
        @total_orders_refund_60 = (@total_orders_refund * 0.6) || 0
        @total_orders_revenue_60 = (@total_orders_revenue  * 0.6) || 0
        @total_Orders_product_cost_60 = (@total_Orders_product_cost * 0.6) || 0
        @total_Orders_product_cost_breakage_60 = (@total_Orders_product_cost_60 * 0.10) || 0
        @actual_media_cost_60 = @actual_media_cost
        @order_media_var_cost_60 = (@order_media_var_cost * 0.6) || 0
        @total_order_profitability_60 = (@total_orders_revenue_60 - (@total_Orders_product_cost_60 + @total_orders_refund_60 + @actual_media_cost_60 +   @total_Orders_product_cost_breakage_60 + @order_media_var_cost_60)) || 0

        @total_Orders_product_cost__breakage_50 = 0
        @total_orders_sales_50 = (@total_orders_sales * 0.5) || 0
        @total_orders_nos_50 = (@total_orders_nos * 0.5) || 0
          @total_orders_refund_50 = (@total_orders_refund * 0.5) || 0
        @total_orders_revenue_50 = (@total_orders_revenue  * 0.5) || 0
        @total_Orders_product_cost_50 = (@total_Orders_product_cost * 0.5) || 0
        @total_Orders_product_cost_breakage_50 = (@total_Orders_product_cost_50 * 0.10) || 0
        @actual_media_cost_50 = @actual_media_cost
        @order_media_var_cost_50 = (@order_media_var_cost * 0.5) || 0
        @total_order_profitability_50 = (@total_orders_revenue_50 - (@total_Orders_product_cost_50 +  @total_Orders_product_cost_breakage_50 + @total_orders_refund_50 + @actual_media_cost_50 +  @order_media_var_cost_50)) || 0
         #@total_order_profitability_50 = (@total_orders_revenue_50 - (@total_Orders_product_cost_50 + @actual_media_cost_50 + @total_Orders_product_cost_breakage_50 + @order_media_var_cost_50)) || 0
        @total_Orders_product_cost__breakage_40 = 0
        @total_orders_sales_40 = (@total_orders_sales * 0.4) || 0
        @total_orders_nos_40 = (@total_orders_nos * 0.4) || 0
        @total_orders_refund_40 = (@total_orders_refund * 0.4) || 0
        @total_orders_revenue_40 = (@total_orders_revenue  * 0.4) || 0
        @total_Orders_product_cost_40 = (@total_Orders_product_cost * 0.4) || 0
        @total_Orders_product_cost_breakage_40 = (@total_Orders_product_cost_40 * 0.10) || 0
        @actual_media_cost_40 = @actual_media_cost
        @order_media_var_cost_40 = (@order_media_var_cost * 0.4) || 0
        @total_order_profitability_40 = (@total_orders_revenue_40 - (@total_Orders_product_cost_40 +  @total_Orders_product_cost_breakage_40 + @total_orders_refund_40 + @actual_media_cost_40 +  @order_media_var_cost_40)) || 0
   

     end
 end


 def media_segments
  @hbnlist = Medium.where(media_group_id: 10000).pluck(:id)
  @paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000").select("id")
  @others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000").select("id")

 end
end
