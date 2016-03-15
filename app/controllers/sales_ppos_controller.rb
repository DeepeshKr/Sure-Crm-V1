class SalesPposController < ApplicationController
  before_action { protect_controllers(5) }
  #before_action :set_sales_ppo, only: [:show, :edit, :update, :destroy]
  before_action :hbn_fixed_costs, only: [:index, :show_wise ] #, :hourly, :hour_performance, :product_performance, :product_hour_performance, :operator_performance, :show, :ppo_products, :channel]
  before_action :all_cancelled_orders
  before_action :view_memory

  # GET /sales_ppos
  # GET /sales_ppos.json
  def index
    @sno = 1

    todaydate = Date.today #Time.zone.now + 330.minutes
    @from_date = todaydate - 1.days #30.days
    @to_date = todaydate
    if params.has_key?(:from_date)
        from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = from_date.to_date - 2.days #30.days
        @to_date = from_date.to_date
    end
    
    @or_for_date = @to_date
    employeeunorderlist ||= []
    @to_date.downto(@from_date).each do |day|
      #byebug
      @from_date = day.beginning_of_day - 330.minutes
      @to_date = day.end_of_day - 330.minutes
      
      orderlist = SalesPpo.where('order_status_id > 10002')
      .where('start_time >= ? AND start_time <= ?', @from_date, @to_date)
      .where.not(order_status_id: @cancelled_status_id)
      ## Apply all the corrections here ###
      total_shipping = (orderlist.sum(:shipping_cost))
      # total_sub_total = (orderlist.sum(:subtotal))
      # totalorders = (total_shipping + total_sub_total)
      gross_sales = orderlist.sum(:gross_sales)

       ## Apply all the corrections here ###
      revenue = orderlist.sum(:revenue)  
      media_var_cost = orderlist.sum(:commission_cost) 
      product_cost = orderlist.sum(:product_cost)
      product_damages = orderlist.sum(:damages) 
      totalorders = orderlist.sum(:gross_sales)
      refund = totalorders * 0.02
      nos = (orderlist.count()) 
      pieces = orderlist.sum(:pieces)
      total_cost = (product_cost + @hbn_media_fixed_cost + media_var_cost + refund + product_damages)
      profitability = (revenue - total_cost).to_i
      
      employeeunorderlist << {:total => totalorders.to_i,
      :for_date => day,
      :pieces => pieces.to_i ,
      :refund => refund.to_i,
      :nos => nos.to_i,
      :total_nos => nos.to_i,
      :revenue => revenue.to_i,
      :product_cost => product_cost.to_i,
      :product_damages => product_damages.to_i,
      :variable_cost => media_var_cost.to_i,
      :fixed_cost => @hbn_media_fixed_cost.to_i,
      :total_cost => total_cost.to_i,
      :profitability => profitability}
    end
        
    #@list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
    @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
    
    @sales_ppos = SalesPpo.where('order_status_id > 10002')
    .where('start_time >= ? AND start_time <= ?', @from_date, @to_date)
    .order("order_id DESC").paginate(:page => params[:page])

  end
  
  def details
    if params.has_key?(:campaign_id)
      
      campaign_playlist_id = params[:campaign_id]
      @campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
      
      @page_heading = "PPO Details #{@campaign_playlist.product_variant.name if @campaign_playlist.product_variant} for #{@campaign_playlist.for_date.strftime('%d-%b-%Y')} #{@campaign_playlist.start_hr.to_s.rjust(2,'0')}: #{@campaign_playlist.start_min.to_s.rjust(2,'0')}:
#{@campaign_playlist.start_sec.to_s.rjust(2, '0')}"
      
      @order_masters = OrderMaster.where(campaign_playlist_id: params[:campaign_id])
         .where('ORDER_STATUS_MASTER_ID > 10002')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .order("created_at")
      
      @sales_ppos = SalesPpo.where('order_status_id > 10002')
      .where.not(order_status_id: @cancelled_status_id)
      .where(campaign_playlist_id: campaign_playlist_id)
      .order("start_time")
      
       #@total_nos = @sales_ppos.count(:id) || 0 if @sales_ppos.present?
       @total_pieces = @sales_ppos.sum(:pieces)
       @total_subtotal = @sales_ppos.sum(:net_sale)
       @total_shipping = @sales_ppos.sum(:shipping_cost)
       @total_sales = @sales_ppos.sum(:gross_sales)
       @total_revenue = @sales_ppos.sum(:revenue)

       @total_product_cost = @sales_ppos.sum(:product_cost)
       @total_var_cost = @sales_ppos.sum(:commission_cost)
       
       @sales_ppos.each do |order|
         @total_nos =+ 1
         @total_promo_cost += order.promotion_cost if order.promotion_cost.present?
       end
    
    
      start_hr = @campaign_playlist.start_hr
      start_min = @campaign_playlist.start_min
     
        # @order_masters.each do |order |
 #            @total_nos += 1
 #            @total_pieces += order.pieces
 #            @total_subtotal += order.subtotal
 #            @total_shipping += order.shipping
 #            @total_sales += order.total
 #            @total_revenue += order.productrevenue
 #
 #            @total_product_cost += order.productcost
 #            @total_var_cost += order.media_commission
 #            if order.promotion.present?
 #              @total_promo_cost += order.promotion.promo_cost
 #            end
 #        end
 
        @total_fixed_cost = @campaign_playlist.cost
        
        # All Costs
        @total_refund = @total_sales * 0.02
        @total_product_dam_cost  = @total_product_cost * 0.10
        @total_cost_per_order = (@total_product_cost  + @total_var_cost +  @total_refund + @total_promo_cost + @total_product_dam_cost + @total_fixed_cost)
        @cost_per_order = 200
        @total_profit = @total_revenue - @total_cost_per_order
        @profit_per_order  = 200 # @total_profit / @total_nos

        # 60%
         @total_nos_60 = @total_nos * 0.6
         @total_pieces_60 = @total_pieces * 0.6
         @total_subtotal_60 = @total_subtotal * 0.6
         @total_shipping_60 = @total_shipping * 0.6
         @total_sales_60 = @total_sales * 0.6
         @total_revenue_60 = @total_revenue * 0.6
         # 60 costs
         @total_product_cost_60 = @total_product_cost * 0.6
         @total_product_dam_cost_60 = @total_product_dam_cost * 0.6
         @total_promo_cost_60 = @total_promo_cost * 0.6
         @total_var_cost_60 = @total_var_cost * 0.6
         @total_fixed_cost_60 = @total_fixed_cost
         @total_refund_60 = @total_refund * 0.6

         @total_cost_per_order_60 = (@total_product_cost_60  + @total_var_cost_60 +  @total_refund_60 + @total_promo_cost_60 + @total_product_dam_cost_60 + @total_fixed_cost_60)

        # @total_cost_per_order_60 =  @total_cost_per_order * 0.6
         @cost_per_order_60 = 200 #(@total_cost_per_order_60) / @total_nos_60
         @total_profit_60 = @total_revenue_60 - @total_cost_per_order_60
         @profit_per_order_60  = 200 # @total_profit_60 / @total_nos_60

         # all details at 50%
         @total_nos_50 = @total_nos * 0.5
         @total_pieces_50 = @total_pieces * 0.5
         @total_subtotal_50 = @total_subtotal * 0.5
         @total_shipping_50 = @total_shipping * 0.5
         @total_sales_50 = @total_sales * 0.5
         @total_revenue_50 = @total_revenue * 0.5

         @total_product_cost_50 = @total_product_cost * 0.5
         @total_product_dam_cost_50 = @total_product_dam_cost * 0.5
         @total_promo_cost_50 = @total_promo_cost * 0.5
         @total_var_cost_50 = @total_var_cost * 0.5
         @total_fixed_cost_50 = @total_fixed_cost
         @total_refund_50 = @total_refund * 0.5
         @total_profit_50 = (@total_profit * 0.5)

         @total_cost_per_order_50 = (@total_product_cost_50  + @total_var_cost_50 +  @total_refund_50 + @total_promo_cost_50 + @total_product_dam_cost_50 + @total_fixed_cost_50)

         @cost_per_order_50  = 200 #(@total_cost_per_order_50) / @total_nos_50
         @total_profit_50 = @total_revenue_50 - @total_cost_per_order_50
         @profit_per_order_50  = 200 # @total_profit_50 / @total_nos_50

         # all details at 40%
         @total_nos_40 = @total_nos * 0.4
         @total_pieces_40 = @total_pieces * 0.4
         @total_subtotal_40 = @total_subtotal * 0.4
         @total_shipping_40 = @total_shipping * 0.4
         @total_sales_40 = @total_sales * 0.4
         @total_revenue_40 = @total_revenue * 0.4
         @total_product_cost_40 = @total_product_cost * 0.4
         @total_product_dam_cost_40 = @total_product_dam_cost * 0.4
         @total_promo_cost_40 = @total_promo_cost * 0.4
         @total_var_cost_40 = @total_var_cost * 0.4
         @total_fixed_cost_40 = @total_fixed_cost
         @total_refund_40 = @total_refund * 0.4

         @total_cost_per_order_40 = (@total_product_cost_40  + @total_var_cost_40 +  @total_refund_40 + @total_promo_cost_40 + @total_product_dam_cost_40 + @total_fixed_cost_40)

         @cost_per_order_40  = 200 # (@total_cost_per_order_40) / @total_nos_40
         @total_profit_40 = @total_revenue_40 - @total_cost_per_order_40
         @profit_per_order_40  = 200 # @total_profit_40 / @total_nos_40


      ordernos = @sales_ppos.pluck(:order_id)
      main_product_type_id = 10000
      basic_product_type_id = 10040
      common_product_type_id = 10001
      
      @regular_basic,   @regular_shipping,  @regular_total,   @regular_cost,  @regular_revenue = 0,0,0,0,0
      @basic_basic,   @basic_shipping,  @basic_total,   @basic_cost,  @basic_revenue = 0,0,0,0,0
      @common_basic,   @common_shipping,  @common_total,   @common_cost,  @common_revenue = 0,0,0,0,0
   
      @order_lines_regular = OrderLine.where(orderid: ordernos)
      .joins(:product_variant)
      .where("product_variants.product_sell_type_id = ?", main_product_type_id)
      .order("order_lines.created_at")


          @order_lines_regular.each do |order |
            @regular_basic += order.subtotal
            @regular_shipping += order.shipping
            @regular_total += order.total
            @regular_cost += order.productcost
            @regular_revenue += order.productrevenue
          end

       
      @order_lines_basic = OrderLine.where(orderid: ordernos).joins(:product_variant)
      .where("product_variants.product_sell_type_id = ?", basic_product_type_id)
      .order("order_lines.created_at")

         @order_lines_basic.each do |order |
            @basic_basic += order.subtotal
            @basic_shipping += order.shipping
            @basic_total += order.total
            @basic_cost += order.productcost
            @basic_revenue += order.productrevenue

          end

      @order_lines_common = OrderLine.where(orderid: ordernos).joins(:product_variant)
      .where("product_variants.product_sell_type_id = ?", common_product_type_id)
      .order("order_lines.created_at")

            @order_lines_common.each do |order |
            @common_basic += order.subtotal
            @common_shipping += order.shipping
            @common_total += order.total
            @common_cost += order.productcost
            @common_revenue += order.productrevenue
          end
        end
  end
  
  def half_hour
    @searchaction = "half_hour"
     #/sales_report/hourly?for_date=05%2F09%2F2015
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
   for_date = (330.minutes).from_now.to_date

    if params.has_key?(:from_date)
     for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @or_for_date = for_date.strftime("%Y-%m-%d")
    end
  
        @hourlist ||= []
        employeeunorderlist ||= []

        @from_date = for_date.beginning_of_day - 300.minutes
        @to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN
        nos = 0
        total_order_value = 0
                
        (@from_date.to_datetime.to_i .. @to_date.to_datetime.to_i).step(30.minutes) do |date|

         halfhourago = Time.at(date - 30.minutes)

          orderlist = SalesPpo.where('order_status_id > 10002')
          .joins(:medium).where("media.media_group_id = 10000")
          .where('start_time >= ? AND start_time <= ?', halfhourago, Time.at(date))
          .where.not(order_status_id: @cancelled_status_id)
          
          @list_of_orders ||= []
            start_hr = halfhourago.strftime("%H")
            start_min = halfhourago.strftime("%M")
            end_hr = Time.at(date).strftime("%H")
            end_min = Time.at(date).strftime("%M")
            media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
            @hbn_media_fixed_cost = media_cost_master.first.total_cost.to_i || 0 if media_cost_master.present?

            ## Apply all the corrections here ###
            shipping_cost = orderlist.sum(:shipping_cost) || 0  if orderlist.present?
            totalorders = orderlist.sum(:net_sale) || 0  if orderlist.present?
     
            # new process
            media_var_cost = orderlist.sum(:commission_cost) || 0  if orderlist.present?
          
            revenue = orderlist.sum(:revenue) || 0 if orderlist.present?
            product_cost = orderlist.sum(:product_cost) || 0  if orderlist.present?
            product_damages = orderlist.sum(:damages) || 0  if orderlist.present? 
            totalorders = orderlist.sum(:gross_sales) || 0  if orderlist.present?
            refund = (totalorders * 0.02)|| 0  if orderlist.present?
            nos = (orderlist.count()) || 0  if orderlist.present?
            pieces = orderlist.sum(:pieces) || 0  if orderlist.present?
            total_cost = ((product_cost || 0) + (@hbn_media_fixed_cost || 0) + (media_var_cost || 0) + (refund || 0) + (product_damages || 0))
            profitability = ((revenue || 0) - (total_cost || 0)).to_i
         
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
            :product_damages => product_damages.to_i,
            :fixed_cost => @media_fixed_cost.to_i,
            :profitability => profitability.to_i}
        end
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
          respond_to do |format|
            csv_file_name = "half_hour_ppo_summary_#{@or_for_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
    @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
  end
  
  def show_wise

    @searchaction = "show_wise"
    for_date = (330.minutes).from_now.to_date
    to_date = for_date + 1.day
    if params.has_key?(:from_date)
     for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
     @from_date = for_date.beginning_of_day - 330.minutes
     @to_date = for_date.end_of_day - 330.minutes
     @or_for_date = for_date.strftime("%Y-%m-%d")
    end
    @sno = 1
    @hourlist ||= []
    employeeunorderlist ||= []

    #@for_date = @campaign.startdate
     campaign_playlists =  CampaignPlaylist.joins(:campaign)
     .where("campaigns.startdate = ?", for_date)
     .order(:start_hr, :start_min, :start_sec)
     .where(list_status_id: 10000) #.limit(5)

     @total_fixed_cost = campaign_playlists.sum(:cost).to_f
     secs_in_a_day = (24*60*60)
     media_cost = @total_fixed_cost / secs_in_a_day

     @serial_no = 1
     campaign_playlists.each do | playlist |

           orderlist = SalesPpo.where('order_status_id > 10002')
           .where.not(order_status_id: @cancelled_status_id)
           .where(campaign_playlist_id: playlist.id)
  
           nos = 0
           # new process
           media_var_cost = orderlist.sum(:commission_cost) || 0  if orderlist.present?
         
           revenue = orderlist.sum(:revenue) || 0 if orderlist.present?
           product_cost = orderlist.sum(:product_cost) || 0  if orderlist.present?
           product_damages = orderlist.sum(:damages) || 0  if orderlist.present? 
           totalorders = orderlist.sum(:gross_sales) || 0  if orderlist.present?
           refund = (totalorders * 0.02)|| 0  if orderlist.present?
           nos = orderlist.count().round(2)|| 0  if orderlist.present?
           pieces = orderlist.sum(:pieces) || 0  if orderlist.present?
           total_cost = ((product_cost || 0) + (@total_fixed_cost || 0) + (media_var_cost || 0) + (refund || 0) + (product_damages || 0))
           profitability = ((revenue || 0) - (total_cost || 0)).to_i
        
          ### check if product cost is found in product master
          product_cost_master = 0
          if ProductCostMaster.where(prod: playlist.product_variant.extproductcode).present?
            product_cost_master = ProductCostMaster.where(prod: playlist.product_variant.extproductcode).first.cost
          end

          employeeunorderlist << {:serial_no => @serial_no,
            :show =>  playlist.product_variant.name,
          :campaign_id => playlist.id,
          :product_cost_master => product_cost_master,
          :pieces => pieces.to_i,
          :prod => playlist.product_variant.extproductcode,
          :nos => nos,
          :at_time => playlist.starttime,
          :product_damages => product_damages.to_i,
          :start_time => @from_date, end_time: @to_date,
          :total => totalorders.to_i,
          :refund => refund.to_i,
          :revenue => revenue.to_i,
          :total_cost => total_cost.to_i,
          :product_cost => product_cost.to_i,
          :variable_cost => media_var_cost.to_i,
          :fixed_cost => @fixed_cost.to_i,
          :profitability => profitability,
          :product_variant_id => playlist.productvariantid}

         @serial_no += 1
      end
      @employeeorderlist = employeeunorderlist
      #@employeeorderlist = @employeeorderlist.paginate(:page => params[:page])
      respond_to do |format|
        csv_file_name = "sales_show_ppo_#{for_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
      end
   #xcel download
  end
  
  def product_performance
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date
    #  @product_lists = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").order('product_lists.name')
    @product_variants = ProductVariant.all.order("name").where("activeid = 10000")

   if params.has_key?(:product_variant_id)
    @product_variant_id = params[:product_variant_id]
    @product_variant = ProductVariant.find(@product_variant_id)
   end
  #  if params.has_key?(:product_list_id)
  #   @product_list_id = params[:product_list_id]
  #   @product_list = ProductList.find(@product_list_id)
  #  end
   if params.has_key?(:from_date)
     @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
     @or_for_date = for_date.strftime("%Y-%m-%d")
   end
     @to_date = (330.minutes).from_now.to_date
   if params.has_key?(:to_date)
     @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
   end

   if @product_variant_id == nil && @from_date == nil && @to_date == nil
     return
   end
       
        @hourlist ||= []
        @halfhourlist ||= []
        employeeunorderlist ||= []

        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN
        check_from_date = corrected_date_time(to_date, "9", "30")
        check_upto_date = corrected_date_time(to_date, "10", "00")

        nos = 0
        total_order_value = 0
        s_no_i = 1
        @serial_no = 1
        campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", 
        @from_date, @to_date).where(list_status_id: 10000).order("for_date, start_hr, start_min")
        @total_fixed_cost = campaign_playlists.sum(:cost).to_f

        campaign_playlists.each do | playlist |

          #  @orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          #  .where(campaign_playlist_id: playlist.id).joins(:order_line)
          #  .where("order_lines.product_list_id in (?)", @product_list_id)
          #  .pluck(:id)
           
           @orderlist = SalesPpo.where('order_status_id > 10002')
           .joins(:medium).where("media.media_group_id = 10000")
           .where.not(order_status_id: @cancelled_status_id)
           .where(campaign_playlist_id: playlist.id)
            .where(product_variant_id: @product_variant_id)
           .pluck(:id)
          
         
           #.limit(10)
             @correction = 1
           @orderlistcount = @orderlist.count
          if @orderlist.present?
                revenue = 0
                #OrderLine.where(orderid: orderlist)
                media_var_cost = 0
                product_cost = 0
                nos = 0.0
                pieces = 0.0
                totalorders = 0.0
                @fixed_cost = playlist.cost
                OrderMaster.where(id: @orderlist).each { |med_com|
                  media_var_cost += med_com.media_commission
                  revenue += med_com.productrevenue
                }
                ####
                ###
                ####
                
                
                media_cost_master = MediaCostMaster.where(media_id: 11200).where("str_hr = ? AND str_min = ? AND end_hr = ? AND end_min = ?", start_hr, start_min, end_hr, end_min)
                @hbn_media_fixed_cost = media_cost_master.first.total_cost.to_i || 0 if media_cost_master.present?

                ## Apply all the corrections here ###
                shipping_cost = orderlist.sum(:shipping_cost) || 0  if orderlist.present?
                totalorders = orderlist.sum(:net_sale) || 0  if orderlist.present?
     
                # new process
                media_var_cost = orderlist.sum(:commission_cost) || 0  if orderlist.present?
          
                revenue = orderlist.sum(:revenue) || 0 if orderlist.present?
                product_cost = orderlist.sum(:product_cost) || 0  if orderlist.present?
                product_damages = orderlist.sum(:damages) || 0  if orderlist.present? 
                totalorders = orderlist.sum(:gross_sales) || 0  if orderlist.present?
                refund = (totalorders * 0.02)|| 0  if orderlist.present?
                nos = (orderlist.count()) || 0  if orderlist.present?
                pieces = orderlist.sum(:pieces) || 0  if orderlist.present?
                total_cost = ((product_cost || 0) + (@hbn_media_fixed_cost || 0) + (media_var_cost || 0) + (refund || 0) + (product_damages || 0))
                profitability = ((revenue || 0) - (total_cost || 0)).to_i
                
                
                
                
                
                ####
                ####
                ###
                
                order_lines = OrderLine.where(orderid: @orderlist)
                order_lines.each do |med |
                #orderlist.each do |med |

                  product_cost += med.productcost
                  pieces += med.pieces
                  totalorders += med.shipping + med.subtotal

                end # ORDER LIST LOOP END
                #nos = orderlist.count()
                #pieces = orderlist.sum(:pieces)
                nos = @orderlist.count
                nos =  nos * @correction

                if nos == 0
                  divide_nos = 1
                else
                  divide_nos = nos
                end

                if nos <= 1
                    @correction = 1
                    nos = 1
                end

                pieces = pieces * @correction
                revenue = revenue * @correction
                # #product_cost = product_cost * nos
                product_cost = (product_cost * @correction)
                product_damages = (product_cost * 0.10)
                totalorders = totalorders * @correction
                media_var_cost = media_var_cost * @correction
                refund = totalorders * 0.02


                total_cost = (product_cost + @fixed_cost + product_damages + media_var_cost + refund)
                profitability = revenue - total_cost
                ppo = (profitability/ divide_nos).to_i

                ### check if product cost is found in product master
                product_cost_master = 0
                if ProductCostMaster.where(prod: playlist.product_variant.extproductcode).present?
                  product_cost_master = ProductCostMaster.where(prod: playlist.product_variant.extproductcode).first.cost
                end

                employeeunorderlist << {:serial_no => @serial_no,
                :show =>  playlist.product_variant.name,
                :correction =>  @correction,
                :for_date => playlist.for_date,
                :campaign_id => playlist.id,
                :product_cost_master => product_cost_master,
                :pieces => pieces.to_i,
                :prod => playlist.product_variant.extproductcode,
                :nos => nos.round(2),
                :at_time => playlist.starttime,
                :product_damages => product_damages.to_i,
                :start_time => @from_date, end_time: @to_date,
                :total => totalorders.to_i,
                :refund => refund.to_i,
                :revenue => revenue.to_i,
                :total_cost => total_cost.to_i,
                :product_cost => product_cost.to_i,
                :variable_cost => media_var_cost.to_i,
                :fixed_cost => @fixed_cost.to_i,
                :ppo => ppo,
                :profitability => profitability.round(0),
                :product_variant_id => playlist.productvariantid}

               @serial_no += 1
            end #if order list present
           end
           @report_results = "Searched for dates #{@from_date} to #{@to_date} and nothing found"
           @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
          respond_to do |format|
            csv_file_name = "Product_performance_between_#{@from_date}_ #{@to_date}.csv"
              format.html

              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
              end
          end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_ppo_params
      params.require(:sales_ppo).permit(:campaign_playlist_id, :campaign_id,
      :product_master_id, :product_variant_id, :product_list_id, :prod, :name,
      :start_time, :order_id, :order_line_id, :product_cost, :pieces,
      :revenue, :damages, :returns, :commission_cost, :promotion_cost,
      :gross_sales, :net_sale, :external_order_no, :order_status_id,
      :order_last_mile_id, :order_pincode, :media_id, :promo_cost_total,
      :dnis, :city, :state, :mobile_no)
    end

    def hbn_fixed_costs
      @all_fixed_media  = Medium.where(media_commision_id: 10000)
      @hbn_media = @all_fixed_media.where(media_group_id: 10000, active: true, media_commision_id: 10000)
      @total_media_cost = @all_fixed_media.sum(:daily_charges).to_f
      @hbn_media_fixed_cost = @hbn_media.sum(:daily_charges).to_f
      @hbn_media_cost = @hbn_media_fixed_cost.round(2)
      @fixed_cost = @hbn_media.sum(:daily_charges).to_f
      
    end
    
    def all_cancelled_orders
      @cancelled_status_id = [10040, 10006, 10008]
      #10040 => tranfer order cancelled
      #10006 => CFO and cancelled orders / unclaimed orders
      #10008 => Returned Order (post shipping)
      #session[:cancelled_status_id] = @cancelled_status_id
    end
    def view_memory
      @total_nos = 0
      @total_pieces = 0
      @total_sales = 0
      @total_revenue = 0
      @total_product_cost = 0
      @total_fixed_cost = 0
      @total_var_cost = 0
      @total_refund = 0
      @total_profit = 0
      @total_damages = 0
      @total_ppo = 0
      
      @total_subtotal = 0
      @total_shipping = 0
      
      @total_cost = 0
      @total_refund = 0
      @total_profit = 0
      @cost_per_order = 0
      @profit_per_order = 0
      @total_promo_cost = 0
    end
    
  end
