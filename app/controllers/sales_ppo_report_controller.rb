class SalesPpoReportController < ApplicationController
  before_action { protect_controllers(5) } 
  before_action :media_segments, only: [:daily, :hourly, :show, :channel]
  before_action :constants
  def summary
    @sno = 1
    @searchaction = "summary"
    @datelist ||= []
    employeeunorderlist ||= []
        
    if params.has_key?(:for_date)
          for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
        
          @from_date = for_date.to_date - 0.days #30.days
          @up_to_date = for_date.to_date 
    else
          use_date = (330.minutes).from_now.to_date
          @from_date = use_date.to_date - 1.days #30.days
          @up_to_date = use_date.to_date #- 5.days
    end
      
    media_segments
        
    @up_to_date.downto(@from_date).each do |day|
           # day = day - 330.minutes
          @datelist <<  day.strftime('%y-%b-%d')
          
          for_date = day # Date.
          @or_for_date = for_date

          @from_date = for_date.beginning_of_day - 330.minutes
          @to_date = for_date.end_of_day - 330.minutes
           
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where(media_id: @hbnlist)

          # #split the fixed cost across the hour
          revenue = 0
          media_var_cost = 0
          product_cost = 0

          @list_of_orders ||= []
          
          orderlist.each do |med |
            @list_of_orders << {order_no:  med.id,
             time_of_order: med.orderdate.strftime('%Y-%b-%d %H:%M:%S')}
            #error loggin
                          
            revenue += OrderMaster.find(med.id).productrevenue  ||= 0
            media_var_cost += OrderMaster.find(med.id).media_commission ||= 0
            product_cost += OrderMaster.find(med.id).productcost ||= 0 

          end
          fixed_cost = Medium.where(media_group_id: 10000).sum(:daily_charges)
          
          ## Apply all the corrections here ###
          total_shipping = (orderlist.sum(:shipping)) 
          total_sub_total = (orderlist.sum(:subtotal)) 
          totalorders = (total_shipping + total_sub_total)

           ## Apply all the corrections here ###
          product_cost = product_cost * @correction
          product_cost += product_cost * 0.10
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
          nos = (orderlist.count()) * @correction
          pieces = orderlist.sum(:pieces) * @correction
          profitability = (revenue - (product_cost + fixed_cost + media_var_cost + refund)).to_i 

          employeeunorderlist << {:total => totalorders.to_i,
          :for_date =>  for_date.strftime("%Y-%m-%d"),
          :pieces => pieces.to_i ,
          :refund => refund.to_i,
          :nos => nos.to_i,
          :total_nos => nos.to_i,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => profitability}
    end
        @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
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
    end
        @total_nos = 0
        @total_pieces = 0
        @total_sales = 0
        @total_revenue = 0

        @total_product_cost = 0
        @total_fixed_cost = 0
        @total_var_cost = 0
        @total_refund = 0

        @total_profit = 0    
       
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []
    
        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN
        
        nos = 0
        total_order_value = 0
        #start loop
        
        (from_date.to_datetime.to_i .. to_date.to_datetime.to_i).step(30.minutes) do |date|
         
         halfhourago = Time.at(date - 30.minutes) 
        
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where(media_id: @hbnlist)
          .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          #add orders of each cable tv operator

          #split the fixed cost across the hour
          revenue = 0
          fixed_cost = 0
          media_var_cost = 0
          product_cost = 0
          media_cost_master = 0
          @list_of_orders ||= []
          
          orderlist.each do |med |

            @list_of_orders << {order_no:  med.id,
            time_of_order: med.orderdate.strftime('%Y-%b-%d %H:%M:%S')}
            #error loggin
            product_cost += med.productcost ||= 0
            revenue += med.productrevenue  ||= 0
            media_var_cost += med.media_commission ||= 0
          end
         
          start_hr = halfhourago.strftime("%H")
          start_min = halfhourago.strftime("%M")
          end_hr = Time.at(date).strftime("%H")
          end_min = Time.at(date).strftime("%M")
          media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
          media_fixed_cost = media_cost_master.first.total_cost.to_i
         
          ## Apply all the corrections here ###
          total_shipping = (orderlist.sum(:shipping)) 
          total_sub_total = (orderlist.sum(:subtotal)) 
          totalorders = (total_shipping + total_sub_total)

           ## Apply all the corrections here ###
          revenue = revenue * @correction
          product_cost = product_cost * @correction
          product_cost += product_cost * 0.10
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
          nos = (orderlist.count()) * @correction
          pieces = orderlist.sum(:pieces) * @correction
          profitability = (revenue - (product_cost + fixed_cost + media_var_cost + refund)).to_i 

          
          employeeunorderlist << {:total => totalorders.to_i,
          :total_orders => totalorders.to_i,
          :starttime =>  halfhourago.strftime("%H:%M %p"),
          :endtime => Time.at(date).strftime("%H:%M %p"),
          :start_time => halfhourago.strftime("%Y-%m-%d %H:%M"), 
          :end_time => Time.at(date).strftime("%Y-%m-%d %H:%M"),
          :pieces => pieces.to_i,
          :total_pieces => pieces.to_i,
          :refund => refund.to_i,
          :nos => nos.to_i,
          :total_nos => nos.to_i,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => media_fixed_cost.to_i,
          :profitability => profitability.to_i}
        end
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
          respond_to do |format|
            csv_file_name = "half_hourly_summary_#{@or_for_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
    @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
  end

  def show
    #add this link to show
    #<%= link_to "View PPO", ppo_details_path(campaign_id: c[:campaign_id]), :target => "_blank" %> 

    @searchaction = "show"
    for_date = (330.minutes).from_now.to_date
    to_date = for_date + 1.day
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
     @from_date = for_date.beginning_of_day - 330.minutes
     @to_date = for_date.end_of_day - 330.minutes
    end
    @sno = 1
   
        @total_orders_nos = 0
        @total_orders_pieces = 0
        @total_orders_sales = 0
        @total_orders_revenue = 0
        @total_orders_media_var_cost = 0
        @total_orders_media_fixed_cost = 0
        @total_orders_refund = 0         
        @total_orders_product_cost = 0
        @total_order_profitability = 0
       
      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []

    @searchaction = 'show'

    @total_orders_media_fixed_cost = Medium.where(media_group_id: 10000).sum(:daily_charges)

    all_orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
           .where('orderdate >= ? AND orderdate <= ?', for_date, to_date)
           .where(media_id: @hbnlist) #.limit(10)

    all_orderlist.each do |med |
      @total_orders_product_cost += med.productcost ||= 0
      @total_orders_revenue += med.productrevenue  ||= 0
      @total_orders_media_var_cost += med.media_commission ||= 0
      @total_orders_nos += 1
    end

       ## Add all the totals here ###
          @total_order_shipping = (all_orderlist.sum(:shipping)) 
          @total_order_sub_total = (all_orderlist.sum(:subtotal)) 
          @total_orders_sales = (@total_order_shipping + @total_order_sub_total)
          @total_orders_pieces = (all_orderlist.sum(:pieces)) 

           ## Apply all the corrections here ###
          @total_orders_nos = @total_orders_nos* @correction
          @total_orders_pieces = @total_orders_pieces * @correction
          @total_orders_revenue = @total_orders_revenue * @correction
          @total_orders_product_cost = @total_orders_product_cost * @correction
          @total_orders_product_cost += @total_orders_product_cost * 0.10
          @total_orders_sales = @total_orders_sales * @correction
          @total_orders_refund = @total_orders_sales * 0.02
          
          @total_order_profitability = (@total_orders_revenue - (@total_orders_product_cost + @total_orders_media_fixed_cost + @total_orders_media_var_cost + @total_orders_refund)).to_i 


      @total_nos = 0
      @total_pieces = 0
      @total_sales = 0
      @total_revenue = 0
      @total_product_cost = 0
      @total_var_cost = 0
      @total_fixed_cost = 0
      @total_cost = 0
      @total_refund = 0
      @total_profit = 0

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

          revenue = 0
          media_var_cost = 0
          product_cost = 0
          fixed_cost = playlist.cost

          orderlist.each do |med |
            product_cost += med.productcost ||= 0
            revenue += med.productrevenue  ||= 0
            media_var_cost += med.media_commission ||= 0
          end

          total_shipping = orderlist.sum(:shipping)
          total_sub_total = orderlist.sum(:subtotal) 
          totalorders = total_shipping + total_sub_total
          nos = orderlist.count()
          pieces = orderlist.sum(:pieces)
          revenue = revenue * @correction
          product_cost = (product_cost * @correction) 
          product_cost += (product_cost * 0.10)
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
        
          nos +=  nos * @correction
          pieces += pieces * @correction
          profitability = (revenue - (product_cost + fixed_cost + media_var_cost + refund)).to_i 

          ### check if product cost is found in product master
          product_cost_master = 0
          if ProductCostMaster.where(prod: playlist.product_variant.extproductcode).present?
            product_cost_master = ProductCostMaster.where(prod: playlist.product_variant.extproductcode).first.cost
          end

          employeeunorderlist << {:show =>  playlist.product_variant.name,
          :campaign_id => playlist.id,
          :product_cost_master => product_cost_master,
          :pieces => pieces.to_i,
          :nos => nos.to_i,
          :at_time => playlist.starttime,
          :start_time => @from_date, end_time: @to_date,
          :total => totalorders.to_i,
          :refund => refund.to_i,
          :revenue => revenue.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => profitability,
          :product_variant_id => playlist.productvariantid}
        end
        @employeeorderlist = employeeunorderlist

   
  end

  def show_ppo_details
   
    #aggregation based on products 
    @sno = 1
    
    showproducts
    shows_for_variant_for_day #show all the shows for the day for the products

    orders_from_channels #orders from channels (media name)
  end #end of def  
  

  def ppo_details
   
    #aggregation based on products 
    @sno = 1
    @time_sno = 1
    showproducts
    shows_between
    
    between_time #show between timings

    hbn_channels_between #channel between timings
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
        
        start_hr = @start_time.strftime("%H")
        start_min = @start_time.strftime("%M")
        end_hr = @end_time.strftime("%H")
        end_min = @end_time.strftime("%M")

        media_fixed_cost = 0
        media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
        if media_cost_master.present?
         media_fixed_cost = media_cost_master.first.total_cost.to_i
        end

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
            product_cost += med.productcost ||= 0
            revenue += med.productrevenue  ||= 0
            media_var_cost += med.media_commission ||= 0
          end

          divided = 30 #divide the cost by 30 minutes to get cost per minute
          fixed_cost = media_fixed_cost / divided
         
         ## Apply all the corrections here ###
          total_shipping = (orderlist.sum(:shipping)) 
          total_sub_total = (orderlist.sum(:subtotal)) 
          totalorders = (total_shipping + total_sub_total)

           ## Apply all the corrections here ###
          revenue = revenue * @correction
          product_cost = product_cost * @correction
          product_cost += product_cost * 0.10
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
          nos = (orderlist.count()) * @correction
          pieces = orderlist.sum(:pieces) * @correction
          profitability = (revenue - (product_cost + fixed_cost + media_var_cost + refund)).to_i 

          employeeunorderlist << {:total => totalorders,
          :starttime =>  halfhourago.strftime("%H:%M %p"),
          :endtime => Time.at(date).strftime("%H:%M %p"),
          :start_time => halfhourago.strftime("%Y-%m-%d %H:%M"), 
          :end_time => Time.at(date).strftime("%Y-%m-%d %H:%M"),
          :nos => nos,
          :pieces => pieces,
          :revenue => revenue,
          :refund => refund,
          :product_cost => product_cost,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => fixed_cost.to_i,
          :profitability => profitability }
        end
       @timelist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse 
     end
  end

def hbn_channels_between
   #media segregation only HBN
    media_segments
    value_now = 0
   media_correction = 0.5
   timetaken = 0
   media_var_cost = 0
    if params.has_key?(:start_time) && params.has_key?(:end_time)
      #  @or_for_date = params[:for_date]
      # for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        if params.has_key?(:product_variant)
        ###########################
        #for a particular show only
        #############
        @hbn_product_orders = OrderLine.joins(:order_master)
        .where('ordermasters.orderdate >= ?', params[:start_time])
        .where('ordermasters.ORDER_STATUS_MASTER_ID > 10002')
        .where("ordermasters.media_id in (@hbnlist)")
        .where(productvariant_id: params[:product_variant])
        .select("orderid").distinct

        hbn_order_masters = OrderMaster.where(orderid: @hbn_order_masters)
        .select(:media_id).distinct #.limit(10)
        hbn_order_list ||= []

       hbn_order_masters.each do |o| #hbn order loop begin
            e = o.media_id
           
            name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
            orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
            .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
            .where(media_id: e)

            orderlist.each {|ol| timetaken += ol.timetaken  }
            orderlist.each {|ol| media_var_cost += ol.media_commission  }
           
             
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            hbn_order_list << {:total => totalorders,
            :id => e, :channel => name, :for_date =>  @or_for_date,
            :nos => noorders, :correction => media_correction,
            :commission => media_var_cost }

          end
        else
        
        hbn_order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
        .where(media_id: @hbnlist).select(:media_id).distinct

         hbn_order_list ||= []

       hbn_order_masters.each do |o| #hbn order loop begin
            e = o.media_id
           
            name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
            orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
            .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
            .where(media_id: e)

            orderlist.each {|ol| timetaken += ol.timetaken  }
            orderlist.each {|ol| media_var_cost += ol.media_commission  }
           
             
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            hbn_order_list << {:total => totalorders,
            :id => e, :channel => name, 
            :nos => noorders, :correction => media_correction,
            :commission => media_var_cost.to_i }
       
        end #hbn order loop end
      end
        @hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse 

       
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
     

      @Show_start_time = @start_time.strftime("%H:%M") || 0
      @Show_end_time = @end_time.strftime("%H:%M") || 0

      # @campaign_playlists =  CampaignPlaylist.where(list_status_id: 10000).limit(10)
      @startsecs = ((@start_time.hour) * 60 * 60) + ((@start_time.min) * 60)
      @endsecs = (@end_time.hour * 60 * 60) + (@end_time.min * 60) 

       @campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (start_hr * 60 *60 )  + (start_min *60) <= ?", @startsecs, @endsecs)
       .joins(:campaign).where("campaigns.startdate = ?", for_date)
       .where('campaigns.mediumid IN (?)', @hbnlist)
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
     
      elsif params.has_key?(:product_variant)

        @campaign_playlists =  CampaignPlaylist.joins(:campaign)
        .where("campaigns.startdate >= ?", for_date)
       .where(productvariantid: params[:product_variant])
      .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)
      

    end
   
 end

 def showproducts
   #@summary ||= []
     
    ccvalue = 0
    ccorders = 0
    codorders = 0
    codvalue = 0

   
   #/ppo_details?end_time=2015-08-15+18%3A29%3A59+UTC&product_variant=10585&start_time=2015-08-14+18%3A30%3A00+UTC
        

      

        #media segregation only HBN
        media_segments

     if params.has_key?(:start_time) && params.has_key?(:end_time)
        @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M") 
        @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M") 

        
        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', 
          @start_time, @end_time).where('ORDER_STATUS_MASTER_ID > 10002')
        .where(media_id: @hbnlist).pluck(:id)
          
      if params.has_key?(:product_variant)

        regular_product_variant_list = ProductVariant.where(id: params[:product_variant])   
      else
        total_order_summary(order_masters, @start_time, @end_time )
        regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
       end
        common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
        basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)
     
       #select the product list based on the product selling category regular basic common upsell
      reg_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: regular_product_variant_list).select(:product_list_id).distinct
      basic_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: basic_sell_product_variant_list).select(:product_list_id).distinct
      common_order_lines = OrderLine.where(orderid: order_masters).where(productvariant_id: common_sell_product_variant_list).select(:product_list_id).distinct
   
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
        main_product_list_orderlist ||= []
        num = 1
        
        cost_of_product = 0
        revenue_of_product = 0
        prod = ""

        @main_total_orders_subtotal = 0
        @main_total_orders_shipping = 0
        @main_total_orders_total = 0
        @main_total_orders_nos = 0
        @main_total_orders_revenue = 0
        @main_total_Orders_product_cost = 0


        reg_order_lines.each do |o|
            e = o.product_list_id
           
            name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
            orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
           
            orderlist.each {|ol| revenue_of_product = ol.productrevenue  }
            orderlist.each {|ol| cost_of_product = ol.productcost  }
            
           prod = orderlist.first.product_list.extproductcode
            subtotal = orderlist.sum(:subtotal)
            shipping = orderlist.sum(:shipping)
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            revenue_of_product = revenue_of_product * noorders
            cost_of_product = cost_of_product * noorders 

            main_product_list_orderlist << {:total => totalorders.to_i, 
              :nos => noorders,
              :id => e, :product => name + " " + cost_of_product.to_s + " * " + noorders.to_s, 
              :prod => prod,
              :subtotal => subtotal.to_i, :shipping => shipping.to_i,
              :product_cost => cost_of_product.to_i ,
              :product_revenue => revenue_of_product.to_i }

            @main_total_orders_subtotal += subtotal
            @main_total_orders_shipping += shipping
            @main_total_orders_total += totalorders
            @main_total_orders_nos += noorders
            @main_total_orders_revenue += (revenue_of_product)
            @main_total_Orders_product_cost += cost_of_product

        end
        @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse 

        ##
        #BASIC PRODUCT LIST
        ##
        cost_of_product = 0
        revenue_of_product = 0
        prod = ""

        basic_product_list_orderlist ||= []

        @basic_total_orders_subtotal = 0
        @basic_total_orders_shipping = 0
        @basic_total_orders_total = 0
        @basic_total_orders_nos = 0
        @basic_total_orders_revenue = 0
        @basic_total_Orders_product_cost = 0

        

        basic_order_lines.each do |o|
        e = o.product_list_id
        
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
       
      
          orderlist.each {|ol| revenue_of_product = ol.productrevenue  }
          orderlist.each {|ol| cost_of_product = ol.productcost  }
            
          prod = orderlist.first.product_list.extproductcode
        
        subtotal = orderlist.sum(:subtotal)
        shipping = orderlist.sum(:shipping)
        totalorders = orderlist.sum(:total)
       
        noofpieces = orderlist.sum(:pieces)
        noorders = orderlist.count()
        revenue_of_product = revenue_of_product * noorders
        cost_of_product = cost_of_product * noorders 
         
        basic_product_list_orderlist << {:total => totalorders.to_i,
            :subtotal => subtotal.to_i, :shipping => shipping.to_i,
            :prod => prod,
            :cost_of_product => cost_of_product.to_i, 
            :revenue_of_product => revenue_of_product.to_i,
            :id => e, :product => name, :for_date =>  @or_for_date,
            :product_cost => cost_of_product.to_i, 
            :product_revenue => revenue_of_product.to_i,
            :nos => noorders}
        
        @basic_total_orders_subtotal += subtotal 
        @basic_total_orders_shipping += shipping 
        @basic_total_orders_total += totalorders
        @basic_total_orders_nos = noorders
        @basic_total_orders_revenue += revenue_of_product 
        @basic_total_Orders_product_cost += cost_of_product  

        end

        @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse 
        ##
        #COMMON PRODUCT LIST
        ##
        cost_of_product = 0
        revenue_of_product = 0
        prod = ""

        common_product_list_orderlist ||= []

        @common_total_orders_subtotal = 0
        @common_total_orders_shipping = 0
        @common_total_orders_total = 0
        @common_total_orders_nos = 0
        @common_total_orders_revenue = 0
        @common_total_Orders_product_cost = 0

        common_order_lines.each do |o|
        e = o.product_list_id
        
        name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
        orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
       
        orderlist.each {|ol| revenue_of_product = ol.productrevenue  }
        orderlist.each {|ol| cost_of_product = ol.productcost  }
            
        prod = orderlist.first.product_list.extproductcode

        subtotal = orderlist.sum(:subtotal)
        shipping = orderlist.sum(:shipping)
        totalorders = orderlist.sum(:total)
        
        noorders = orderlist.count()
        revenue_of_product = revenue_of_product * noorders
        cost_of_product = cost_of_product * noorders 

        common_product_list_orderlist << {:total => totalorders.to_i,
           :cost_of_product => cost_of_product, 
           :revenue_of_product => revenue_of_product.to_i,
               :subtotal => subtotal, :shipping => shipping.to_i,
                 :prod => prod,
           :id => e, :product => name, :for_date =>  @or_for_date,
           :product_cost => cost_of_product.to_i,
            :product_revenue => revenue_of_product.to_i ,
          :nos => noorders  }
        
        @common_total_orders_subtotal += subtotal 
        @common_total_orders_shipping += shipping 
        @common_total_orders_total += totalorders
        @common_total_orders_nos += noorders
        @common_total_orders_revenue += revenue_of_product 
        @common_total_Orders_product_cost += cost_of_product

        end

        @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse 
      
        @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse  
      
      end
       
 end
 def total_order_summary(order_masters,start_time,end_time)

        @Show_start_time = start_time.strftime("%H:%M")
        @Show_end_time = end_time.strftime("%H:%M")

        start_hr = start_time.hour
        start_min = start_time.min
        end_hr = end_time.hour
        end_min = end_time.min
         @total_order_fix_media_cost = 
        media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
       if media_cost_master.present?
        @total_order_fix_media_cost = media_cost_master.first.total_cost 
      end

  @total_orders_sales = 0
    @total_orders_nos = 0
    @total_orders_revenue = 0
    @total_Orders_product_cost = 0
    @actual_media_cost = 0
    @total_order_media_var_cost = 0
    @total_order_profitability = 0


        order_master_list = OrderMaster.where(id: order_masters)
          #split the fixed cost across the hour 
          @list_of_orders ||= []
          #@order_media_var_cost_full = 0
           revenue = 0
           media_var_cost = 0
           product_cost = 0

          order_master_list.each do |med |
            @list_of_orders << {order_no:  med.id,
             time_of_order: (med.orderdate + 330.minutes).strftime('%Y-%b-%d %H:%M:%S')}

            product_cost += med.productcost ||= 0
            revenue += med.productrevenue  ||= 0
            @total_order_media_var_cost += med.media_commission ||= 0
           
          end

           
          ## Apply all the corrections here ###
          total_shipping = (order_master_list.sum(:shipping)) 
          total_sub_total = (order_master_list.sum(:subtotal)) 
          @total_orders_sales = (total_shipping + total_sub_total)

           ## Apply all the corrections here ###
          @total_orders_revenue = revenue * @correction
          @total_orders_product_cost = product_cost * @correction
          @total_orders_product_cost +=  @total_orders_product_cost * 0.10
          @total_orders_sales = @total_orders_sales * @correction
          @total_orders_refund = @total_orders_sales * 0.02
          @total_orders_nos = (order_master_list.count()) * @correction
          @total_orders_pieces = order_master_list.sum(:pieces) * @correction
          @total_order_profitability = (@total_orders_revenue - (@total_orders_product_cost + @total_order_fix_media_cost + @total_order_media_var_cost + @total_orders_refund)).to_i 

   @total_orders_product_cost_60 = 0
        @total_orders_sales_60 = (@total_orders_sales * 0.6) || 0
        @total_orders_nos_60 = (@total_orders_nos * 0.6) || 0
        @total_orders_refund_60 = (@total_orders_refund * 0.6) || 0 if @total_orders_refund.presence
        @total_orders_revenue_60 = (@total_orders_revenue  * 0.6) || 0
        @total_orders_product_cost_60 = (@total_orders_product_cost * 0.6) || 0 
        @total_orders_product_cost_60 += (@total_orders_product_cost_60 * 0.10) || 0
        @total_order_media_var_cost_60 = (@total_order_media_var_cost * 0.6) || 0
        #
        @total_order_profitability_60 = (@total_orders_revenue_60 - (@total_orders_product_cost_60  + @total_order_fix_media_cost + @total_orders_refund_60 +  @total_order_media_var_cost_60)) || 0

        @total_orders_product_cost_breakage_50 = 0
        @total_orders_product_cost_50 = 0
        @total_orders_sales_50 = (@total_orders_sales * 0.5) || 0
        @total_orders_nos_50 = (@total_orders_nos * 0.5) || 0
        @total_orders_refund_50 = (@total_orders_refund * 0.5) || 0 if @total_orders_refund.presence
        @total_orders_revenue_50 = (@total_orders_revenue  * 0.5) || 0
        @total_orders_product_cost_50 = (@total_orders_product_cost * 0.5) || 0
        @total_orders_product_cost_50 += (@total_orders_product_cost_50 * 0.10) || 0
        @actual_media_cost_50 = @actual_media_cost
        @total_order_media_var_cost_50 = (@total_order_media_var_cost * 0.5) || 0
        @total_order_profitability_50 = (@total_orders_revenue_50 - 
          (@total_orders_product_cost_50 + @total_order_fix_media_cost +  @total_orders_refund_50 +
            @total_order_media_var_cost_50)) || 0
         #@total_order_profitability_50 = (@total_orders_revenue_50 - (@total_orders_product_cost_50 + @actual_media_cost_50 + @total_Orders_product_cost_breakage_50 + @order_media_var_cost_50)) || 0
        @total_Orders_product_cost_breakage_40 = 0
        @total_orders_sales_40 = (@total_orders_sales * 0.4) || 0
        @total_orders_nos_40 = (@total_orders_nos * 0.4) || 0
        @total_orders_refund_40 = (@total_orders_refund * 0.4) || 0 if @total_orders_refund.presence
        @total_orders_revenue_40 = (@total_orders_revenue  * 0.4) || 0
        @total_orders_product_cost_40 = (@total_orders_product_cost * 0.4) || 0
        @total_orders_product_cost_40 += (@total_orders_product_cost_40 * 0.10) || 0
        @actual_media_cost_40 = @actual_media_cost
        @total_order_media_var_cost_40 = (@total_order_media_var_cost * 0.4) || 0
        @total_order_profitability_40 = (@total_orders_revenue_40 - (@total_orders_product_cost_40 + 
          @total_orders_refund_40 +
         @total_order_fix_media_cost +  @total_order_media_var_cost_40)) || 0

 end
 def constants
   @correction = 1
   @shipping_tax_less = 0.98125
   @subtotal_vat_less = 0.888889
 end

 def media_segments
  @hbnlist = Medium.where(media_group_id: 10000).pluck(:id)
  @paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000").select("id")
  @others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000").select("id")

 end
end
