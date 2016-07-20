class SalesPposController < ApplicationController
  before_action { protect_controllers(5) }
  #before_action :set_sales_ppo, only: [:show, :edit, :update, :destroy]
  before_action :hbn_fixed_costs, only: [:index, :show_wise ] #, :hourly, :hour_performance, :product_performance, :product_hour_performance, :operator_performance, :show, :ppo_products, :channel]
  before_action :all_cancelled_orders
  before_action :view_memory
  before_action :daily_task_ppo_status, only: [:index, :product_performance ]

  # GET /sales_ppos
  # GET /sales_ppos.json
  def index
    @sno = 1
    all_return_rates
    # (Date.current + 330.minutes).strftime("%Y-%m-%d")
    todaydate = Date.today #Time.zone.now + 330.minutes
    @from_date = todaydate - 7.days #30.days
    @to_date = todaydate
    @return_url = request.original_url
    
    if params.has_key?(:from_date)
        from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = from_date.to_date - 7.days #30.days
        @to_date = from_date.to_date
    end
    @regenerate_ppo = "Regenerate PPOS between #{@from_date} and #{@to_date}"
    ppo_sales = SalesPpo.new
    @employeeorderlist = ppo_sales.sales_ppos_between_dates @from_date, @to_date

    @or_for_date = @to_date


  end

  def demo
    end_date = Date.today #Time.zone.now + 330.minutes
    from_date = end_date - 30.days

     ppo_sales = SalesPpo.new

    @sales_ppos = ppo_sales.sales_ppos_for_date from_date, end_date

  end

  def show_all
    @page_heading = "Search in PPO"
    @order_id = nil
    @order_no = nil
    if params.has_key?(:order_no)
      @order_no = params[:order_no]
      @sales_ppos = SalesPpo.where(:external_order_no => @order_no)
      .order("start_time")

      @order_id = @sales_ppos.first.order_id if @sales_ppos.present?
    @page_heading = "PPO for order id #{@order_id}"
    elsif params.has_key?(:order_id)
      @order_id = params[:order_id]
      @sales_ppos = SalesPpo.where(:order_id =>  @order_id)
      .order("start_time")

      @order_no = @sales_ppos.first.external_order_no if @sales_ppos.present?
       @page_heading = "PPO for order ref no #{@order_no}"
    elsif params.has_key?(:campaign_playlist_id)
      @campaign_playlist_id = params[:campaign_playlist_id]
      @sales_ppos = SalesPpo.where("campaign_playlist_id = ? OR campaign_id = ?", @campaign_playlist_id, @campaign_playlist_id)
      .order("start_time")
      @page_heading = "PPO for campaign playlist id #{@campaign_playlist_id}"
    end

  end

  def details

    if params.has_key?(:campaign_id)

      @campaign_playlist_id = params[:campaign_id]
      @campaign_playlist =  CampaignPlaylist.find(@campaign_playlist_id)
      @campaign = Campaign.find(@campaign_playlist.campaignid)
      @product_variant_id = @campaign_playlist.productvariantid

      @product_price = ProductCostMaster.find_by_prod(@campaign_playlist.product_variant.extproductcode).cost

      @page_heading = "PPO Details #{@campaign_playlist.product_variant.name if @campaign_playlist.product_variant}
      for #{@campaign_playlist.for_date.strftime('%d-%b-%Y')} #{@campaign_playlist.start_hr.to_s.rjust(2,'0')}:#{@campaign_playlist.start_min.to_s.rjust(2,'0')}:#{@campaign_playlist.start_sec.to_s.rjust(2, '0')}"

        @from_date = @campaign_playlist.for_date.strftime("%Y-%m-%d")
        @to_date = @campaign_playlist.for_date.strftime("%Y-%m-%d")

      @order_masters = OrderMaster.where(campaign_playlist_id: @campaign_playlist_id)
         .where('ORDER_STATUS_MASTER_ID > 10000')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .order("created_at")

         @all_order_masters = OrderMaster.where(campaign_playlist_id: @campaign_playlist_id)
            .where('ORDER_STATUS_MASTER_ID > 10000').count

      @sales_ppos = SalesPpo.where('order_status_id > 10000')
      .where(campaign_playlist_id: @campaign_playlist_id)
      .order("start_time")
      if params.has_key?(:product_variant_id)
         @product_variant_id = params[:product_variant_id]
         ### product_variant_ids
         @product_variant_ids = []
         @product_variant_ids << @product_variant_id
         if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(@campaign_playlist_id).present?)
           @product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id:@campaign_playlist_id).pluck(:product_variant_id)
         end
         @sales_ppos = @sales_ppos.where(product_variant_id: @product_variant_ids)
       end
       @all_ppo_orders = @sales_ppos.distinct.count('order_id')

      # .where.not(order_status_id: @cancelled_status_id)



       ppo_sales = SalesPpo.new

       @open_orders = ppo_sales.show_open_orders @campaign_playlist_id
       #campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
       @return_rates = ReturnRate.new
        #return_rate = ReturnRate.new
        rate_best_of_threes = @return_rates.retail_best_of_three(@campaign_playlist.productvariantid, @campaign.mediumid)
        @quick_return_rates = @return_rates.retail_best_of_three(@campaign_playlist.productvariantid, @campaign.mediumid)
        rate_best_of_three = rate_best_of_threes.first

        @to_return_rate = @return_rates.transfer_order_default_rate
        @final_return_rate = @return_rates.retail_best_shipped_paid_percent(@campaign_playlist.productvariantid, @campaign.mediumid)
        @to_final_return_rate = @return_rates.transfer_best_shipped_paid_percent(@campaign_playlist.productvariantid, @campaign.mediumid)

        @to_correction = @to_sales_3_mo.correction || 100.0 if @to_sales_3_mo.present?
        # campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results

      if params.has_key?(:product_variant_id)
        @product_variant_id = params[:product_variant_id]
        @product_variant = ProductVariant.find(@product_variant_id)
        @showing_results_for = "Showing results only for product #{@product_variant.name}"
        @retail_sales_all = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, 100.0, 100.0, "retail", @product_variant_id)
        @retail_sales_shipped = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, @return_rates.shipped_percent, 0.0, "retail", @product_variant_id)
        @retail_sales_default = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, @return_rates.retail_default_rate, 0.0, "retail", @product_variant_id)

        @retail_sales_3_mo = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, rate_best_of_three.rate, 0.0, "retail", @product_variant_id)

        @to_sales_all = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, 0.0, 100.0, "to", @product_variant_id)
        @to_sales_shipped = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, 0.0, 80.0, "to", @product_variant_id)
        @to_sales_default = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, 0.0, @return_rates.transfer_order_default_rate, "to", @product_variant_id)

        @to_sales_3_mo = ppo_sales.ppo_product_details(@campaign_playlist_id, false, false, 0.0, @to_final_return_rate.rate_2, "to", @product_variant_id)

        @sales_all = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, 100.0, 100.0, "all", @product_variant_id)
        @sales_shipped = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, @return_rates.shipped_percent, 80.0, "all", @product_variant_id)
        @sales_default = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, @return_rates.retail_default_rate, @return_rates.transfer_order_default_rate, "all", @product_variant_id)
        @sales_3_mo = ppo_sales.ppo_product_details(@campaign_playlist_id, true, false, rate_best_of_three.rate, @to_final_return_rate.rate_2, "all", @product_variant_id)

      else
        @product_variant_id = nil
        @showing_results_for = "Showing resuls for show #{@campaign_playlist.name}"
        @retail_sales_all = ppo_sales.ppo_details(@campaign_playlist_id, true, false, 100.0, 100.0, "retail")
        @retail_sales_shipped = ppo_sales.ppo_details(@campaign_playlist_id, true, false, @return_rates.shipped_percent, 0.0, "retail")
        @retail_sales_default = ppo_sales.ppo_details(@campaign_playlist_id, true, false, @return_rates.retail_default_rate, 0.0, "retail")
        @retail_sales_3_mo = ppo_sales.ppo_details(@campaign_playlist_id, true, false, rate_best_of_three.rate, 0.0, "retail")

        @to_sales_all = ppo_sales.ppo_details(@campaign_playlist_id, true, false, 0.0, 100.0, "to")
        @to_sales_shipped = ppo_sales.ppo_details(@campaign_playlist_id, true, false, 0.0, 80.0, "to")
        @to_sales_default = ppo_sales.ppo_details(@campaign_playlist_id, true, false, 0.0, @return_rates.transfer_order_default_rate, "to")
        @to_sales_3_mo = ppo_sales.ppo_details(@campaign_playlist_id, false, false, 0.0, @to_final_return_rate.rate_2, "to")

        @sales_all = ppo_sales.ppo_details(@campaign_playlist_id, true, false, 100.0, 100.0, "all")
        @sales_shipped = ppo_sales.ppo_details(@campaign_playlist_id, true, false, @return_rates.shipped_percent, 80.0, "all")
        @sales_default = ppo_sales.ppo_details(@campaign_playlist_id, true, false, @return_rates.retail_default_rate, @return_rates.transfer_order_default_rate, "all")
        @sales_3_mo = ppo_sales.ppo_details(@campaign_playlist_id, true, false, rate_best_of_three.rate, @to_final_return_rate.rate_2, "all")
       end

      start_hr = @campaign_playlist.start_hr
      start_min = @campaign_playlist.start_min

      ordernos = @order_masters.pluck(:id) #@sales_ppos.pluck(:order_id)
      main_product_type_id = 10000
      basic_product_type_id = 10040
      common_product_type_id = 10001

      @regular_basic,   @regular_shipping,  @regular_total,   @regular_cost,  @regular_revenue = 0,0,0,0,0
      @basic_basic,   @basic_shipping,  @basic_total,   @basic_cost,  @basic_revenue = 0,0,0,0,0
      @common_basic,   @common_shipping,  @common_total,   @common_cost,  @common_revenue = 0,0,0,0,0


          if params.has_key?(:product_variant_id)
             @product_variant_id = params[:product_variant_id]
             ### product_variant_ids
             @product_variant_ids = []
             @product_variant_ids << @product_variant_id
             if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(@campaign_playlist_id).present?)

               @product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id:@campaign_playlist_id).pluck(:product_variant_id)
             end
             ### product_variant_ids

             @order_lines_regular = OrderLine.where(productvariant_id: @product_variant_ids)
             .where(orderid: ordernos)
             .joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", main_product_type_id)
             .order("order_lines.created_at")
           else
             @order_lines_regular = OrderLine.where(orderid: ordernos)
             .joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", main_product_type_id)
             .order("order_lines.created_at")
          end

          @order_lines_regular.each do |order |
            @regular_basic += order.subtotal
            @regular_shipping += order.shipping
            @regular_total += order.total
            @regular_cost += order.productcost
            @regular_revenue += order.productrevenue
          end



          if params.has_key?(:product_variant_id)
             @product_variant_id = params[:product_variant_id]
             ### product_variant_ids
             @product_variant_ids = []
             @product_variant_ids << @product_variant_id
             if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(@campaign_playlist_id).present?)
               @product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id:@campaign_playlist_id).pluck(:product_variant_id)
             end
             ### product_variant_ids
             @order_lines_basic = OrderLine.where(productvariant_id:@product_variant_ids)
             .where(orderid: ordernos).joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", basic_product_type_id)
             .order("order_lines.created_at")
           else
             @order_lines_basic = OrderLine.where(orderid: ordernos).joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", basic_product_type_id)
             .order("order_lines.created_at")
          end

          if params.has_key?(:product_variant_id)
             @product_variant_id = params[:product_variant_id]
             ### product_variant_ids
             @product_variant_ids = []
             @product_variant_ids << @product_variant_id
             if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(@campaign_playlist_id).present?)
               @product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id:@campaign_playlist_id).pluck(:product_variant_id)
             end
             ### product_variant_ids
             @order_lines_basic.where(productvariant_id:@product_variant_ids)

          end

          @order_lines_basic.each do |order |
            @basic_basic += order.subtotal
            @basic_shipping += order.shipping
            @basic_total += order.total
            @basic_cost += order.productcost
            @basic_revenue += order.productrevenue
          end



          if params.has_key?(:product_variant_id)
             @product_variant_id = params[:product_variant_id]
             ### product_variant_ids
             @product_variant_ids = []
             @product_variant_ids << @product_variant_id
             if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(@campaign_playlist_id).present?)
              @product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id:@campaign_playlist_id).pluck(:product_variant_id)
             end
             ### product_variant_ids
             @order_lines_common = OrderLine.where(productvariant_id:@product_variant_ids)
             .where(orderid: ordernos).joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", common_product_type_id)
             .order("order_lines.created_at")
           else
             @order_lines_common = OrderLine.where(orderid: ordernos).joins(:product_variant)
             .where("product_variants.product_sell_type_id = ?", common_product_type_id)
             .order("order_lines.created_at")
          end

            @order_lines_common.each do |order |
            @common_basic += order.subtotal
            @common_shipping += order.shipping
            @common_total += order.total
            @common_cost += order.productcost
            @common_revenue += order.productrevenue
          end
           @return_url = request.original_url
            @regenerate_ppo = "Re Generate PPO for #{@product_name} with product price Rs. #{@product_price} between #{@from_date} and #{@to_date} and campaign #{@campaign_playlist.product_variant.name}"

      end
  end

  def half_hourly
    #@searchaction = "hourly"
     #/sales_report/hourly?for_date=05%2F09%2F2015
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
   for_date = (330.minutes).from_now.to_date

    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      @or_for_date = for_date.strftime("%Y-%m-%d")
    end

      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []

        @from_date = for_date.beginning_of_day - 300.minutes
        @to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN

        nos = 0
        total_order_value = 0
        #start loop

        (@from_date.to_datetime.to_i .. @to_date.to_datetime.to_i).step(30.minutes) do |date|

         halfhourago = Time.at(date - 30.minutes)

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
          .where('ORDER_STATUS_MASTER_ID <> 10006')
          .joins(:medium).where("media.media_group_id = 10000")
          .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          #add orders of each cable tv operator

          #split the fixed cost across the hour
          revenue = 0
          fixed_cost = 0
          media_var_cost = 0
          product_cost = 0
          product_damages = 0
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
          @media_fixed_cost = media_cost_master.first.total_cost.to_i ||= 0

          ## Apply all the corrections here ###
          total_shipping = (orderlist.sum(:shipping))
          total_sub_total = (orderlist.sum(:subtotal))
          totalorders = (total_shipping + total_sub_total)

           ## Apply all the corrections here ###
          revenue = revenue * @correction
          product_cost = product_cost * @correction
          product_damages = product_cost * 0.10
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
          nos = (orderlist.count()) * @correction
          pieces = orderlist.sum(:pieces) * @correction
          total_cost = (product_cost + @media_fixed_cost + media_var_cost + refund + product_damages).to_i
          profitability = (revenue - total_cost).to_i


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
        ### respond format start
          respond_to do |format|
            csv_file_name = "half_hourly_summary_#{@or_for_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
        ### respond format start
    @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}

  end

  def show_wise
    all_return_rates
    @searchaction = "show_wise"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date
    to_date = for_date + 1.day
    if params.has_key?(:from_date)
     for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
     @from_date = for_date.beginning_of_day - 330.minutes

    @to_date = for_date.end_of_day - 330.minutes
    @or_for_date = for_date.strftime("%Y-%m-%d")

    @page_heading = "PPO Details for #{for_date}"

    ppo_sales = SalesPpo.new
    @employeeorderlist = ppo_sales.sales_ppos_for_date for_date

   end

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

    @return_url = request.original_url
    @total_sales_1, @total_sales_2, @total_revenue_1, @total_revenue_2 = 0,0,0,0
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date

    @product_variants = ProductVariant.all.order("name").where("activeid = 10000")
    @product_name = ""
    @product_price = nil
   if params.has_key?(:product_variant_id)
    @product_variant_id = params[:product_variant_id]
    @product_variant = ProductVariant.find(@product_variant_id)
    @product_name = @product_variant.name
    @product_price = ProductCostMaster.find_by_prod(@product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(@product_variant.extproductcode).present?
   end

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
   #@retail_default = 49
   @retail_default = SalesPpoDefault.find_by_name("Retail").value
   if params.has_key?(:retail_default)
     @retail_default = params[:retail_default]
   end
   #@transfer_default = 65
   @transfer_default = SalesPpoDefault.find_by_name("Transfer Order").value
   if params.has_key?(:transfer_default)
     @transfer_default = params[:transfer_default]
   end

   @sim_product_price = nil
   if params[:sim_product_price].present?
     @sim_product_price = params[:sim_product_price]
   end

   @sim_retail_sales_pieces = nil
   if params[:sim_retail_sales_pieces].present?
     @sim_retail_sales_pieces = params[:sim_retail_sales_pieces]
   end

   @sim_to_sales_pieces = nil
   if params[:sim_to_sales_pieces].present?
     @sim_to_sales_pieces = params[:sim_to_sales_pieces]
   end

   @sim_product_total = nil
   if params[:sim_product_total].present?
     @sim_product_total = params[:sim_product_total]
   end

   @regenerate_ppo = "Re Generate PPO for #{@product_name} with product price Rs. #{@product_price} between #{@from_date} and #{@to_date}"

   ppo_sales = SalesPpo.new
   # change default retail and transfer order conversion rate
   # change product price , ret_def = nil, to_def = nil, product_cost = nil
   @employeeorderlist = ppo_sales.sales_product_ppos_for_date @from_date, @to_date, @product_variant_id, @retail_default, @transfer_default, @sim_product_price, @sim_retail_sales_pieces, @sim_to_sales_pieces, @sim_product_total

   @serial_no += 1

   @report_results = "Searched for dates #{@from_date} to #{@to_date} and nothing found"
   #@employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
    respond_to do |format|
      csv_file_name = "#{@product_name}_#{@product_price}_performance_between_#{@from_date}_#{@to_date}.csv"
        format.html

        #format.csv { send_data @employeeorderlist.to_new_csv}
        #format.csv { send_data @employeeorderlist.to_new_csv, filename: "#{csv_file_name}" }
        format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
        end

        format.json {render json: @employeeorderlist, methods: [:total_product_dam_cost_1, :total_nos_2, :for_date, :show_time, :product_cost, :description, :total_name_1, :total_nos_1, :total_pieces_1, :total_sales_1, :total_revenue_1,:total_product_cost_1,:total_var_cost_1,:total_fixed_cost_1,:total_refund_1,:total_product_dam_cost_1,:profit_per_order_1, :total_name_2,:total_nos_2, :total_pieces_2,:total_sales_2, :total_revenue_2, :total_product_cost_2, :total_var_cost_2, :total_fixed_cost_2, :total_refund_2, :total_product_dam_cost_2, :profit_per_order_2]}
    end
  end
  
  def simulate_product_performance

    @return_url = request.original_url
    @total_sales_1, @total_sales_2, @total_revenue_1, @total_revenue_2 = 0,0,0,0
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date

    @product_variants = ProductVariant.all.order("name").where("activeid = 10000")
    @product_name = ""
    @product_price = nil
   if params.has_key?(:product_variant_id)
    @product_variant_id = params[:product_variant_id]
    @product_variant = ProductVariant.find(@product_variant_id)
    @product_name = @product_variant.name
    @product_price = ProductCostMaster.find_by_prod(@product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(@product_variant.extproductcode).present?
   end

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
   #@retail_default = 49
   @retail_default = SalesPpoDefault.find_by_name("Retail").value
   if params.has_key?(:retail_default)
     @retail_default = params[:retail_default]
   end
   #@transfer_default = 65
   @transfer_default = SalesPpoDefault.find_by_name("Transfer Order").value
   if params.has_key?(:transfer_default)
     @transfer_default = params[:transfer_default]
   end

   @sim_product_price = nil
   if params[:sim_product_price].present?
     @sim_product_price = params[:sim_product_price]
   end

   @sim_retail_sales_pieces = 0
   if params[:sim_retail_sales_pieces].present?
     @sim_retail_sales_pieces = params[:sim_retail_sales_pieces]
   end

   @sim_to_sales_pieces = 0
   if params[:sim_to_sales_pieces].present?
     @sim_to_sales_pieces = params[:sim_to_sales_pieces]
   end
   
   @sim_product_basic = 0
   if params[:sim_product_basic].present?
     @sim_product_basic = params[:sim_product_basic]
   end
   
   @sim_product_shipping = 0
   if params[:sim_product_shipping].present?
     @sim_product_shipping = params[:sim_product_shipping]
   end
   
   @regenerate_ppo = "Re Generate PPO for #{@product_name} with product price Rs. #{@product_price} between #{@from_date} and #{@to_date}"

   ppo_sales = SalesPpo.new
   # change default retail and transfer order conversion rate
   # change product price , ret_def = nil, to_def = nil, product_cost = nil
   @employeeorderlist = ppo_sales.simulate_sales_product_ppos_for_date @from_date, @to_date, @product_variant_id, @retail_default, @transfer_default, @sim_product_price, @sim_retail_sales_pieces, @sim_to_sales_pieces, @sim_product_basic, @sim_product_shipping

   @serial_no += 1

   @report_results = "Searched for dates #{@from_date} to #{@to_date} and nothing found"
   #@employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
    respond_to do |format|
      csv_file_name = "#{@product_name}_#{@product_price}_performance_between_#{@from_date}_#{@to_date}.csv"
        format.html

        #format.csv { send_data @employeeorderlist.to_new_csv}
        #format.csv { send_data @employeeorderlist.to_new_csv, filename: "#{csv_file_name}" }
        format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
        end

        format.json {render json: @employeeorderlist, methods: [:total_product_dam_cost_1, :total_nos_2, :for_date, :show_time, :product_cost, :description, :total_name_1, :total_nos_1, :total_pieces_1, :total_sales_1, :total_revenue_1,:total_product_cost_1,:total_var_cost_1,:total_fixed_cost_1,:total_refund_1,:total_product_dam_cost_1,:profit_per_order_1, :total_name_2,:total_nos_2, :total_pieces_2,:total_sales_2, :total_revenue_2, :total_product_cost_2, :total_var_cost_2, :total_fixed_cost_2, :total_refund_2, :total_product_dam_cost_2, :profit_per_order_2]}
    end
  end
  
  def product_long_term_performance

    @return_url = request.original_url
    @total_sales_1, @total_sales_2, @total_revenue_1, @total_revenue_2 = 0,0,0,0
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "product_long_term_performance"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date

   if params.has_key?(:from_date)
     @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
     @or_for_date = for_date.strftime("%Y-%m-%d")
   end

   @to_date = (330.minutes).from_now.to_date
   if params.has_key?(:to_date)
     @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
   end

   if @from_date == nil && @to_date == nil
     return
   end
  
   ppo_sales = SalesPpo.new
   # change default retail and transfer order conversion rate
   # change product price , ret_def = nil, to_def = nil, product_cost = nil
   @employeeorderlist = ppo_sales.sales_all_product_ppos_between_date @from_date, @to_date, @retail_default, @transfer_default

   @serial_no += 1

   @report_results = "Searched for dates #{@from_date} to #{@to_date} and nothing found"
   #@employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
    respond_to do |format|
      csv_file_name = "Long_term_performance_between_#{@from_date}_#{@to_date}.csv"
        format.html

        #format.csv { send_data @employeeorderlist.to_new_csv}
        #format.csv { send_data @employeeorderlist.to_new_csv, filename: "#{csv_file_name}" }
        format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
        end

    end
  end
  
  def show_performance
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
     @from_date = (330.minutes).from_now.to_date
     for_date = (330.minutes).from_now.to_date

    #  @product_lists = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").order('product_lists.name')

     @product_variants = ProductVariant.all.order("name").where("activeid = 10000")
     @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
     @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f
     #@total_fixed_cost = campaign_playlists.sum(:cost).to_f

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

     ppo_sales = SalesPpo.new
     @employeeorderlist = ppo_sales.sales_show_ppos_for_date @from_date, @to_date, @product_variant_id

     respond_to do |format|
            csv_file_name = "Show_performance_between_#{@from_date}_ #{@to_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end

  end

  def half_hour_sales
    @hbn_media_cost_master = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
    @sno = 1
    @searchaction = "hour_sales_performance"

     for_date = (330.minutes).from_now.to_date
     @from_date = (330.minutes).from_now.to_date
     if params.has_key?(:time_id)
       @time_id = params[:time_id]
     end
     if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @or_for_date = for_date.strftime("%Y-%m-%d")
     end
     @to_date = (330.minutes).from_now.to_date
     if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
     end
     if @time_id == nil || @from_date == nil || @to_date == nil
       return
     end

     #get all the time slot details
     @time_slot = MediaCostMaster.find(@time_id)
     @start_hr = @time_slot.str_hr
     @start_min = @time_slot.str_min
     @end_hr = @time_slot.end_hr
     @end_min = @time_slot.end_min

     employeeunorderlist ||= []
     @to_date.downto(@from_date).each do |day|
     #######################
       sales_ppo_info = SalesPpo.new
       @from_time = sales_ppo_info.corrected_date_time(day, @start_hr, @start_min)
       if @end_hr == 0 && @end_min == 0
          @upto_time = sales_ppo_info.corrected_date_time(day + 1.day, @end_hr, @end_min)
       else
          @upto_time = sales_ppo_info.corrected_date_time(day, @end_hr, @end_min)
       end


        orderlists = SalesPpo.where('ORDER_STATUS_ID > 10002')
          .where.not(ORDER_STATUS_ID: @cancelled_status_id)
        .joins(:medium).where("media.media_group_id = 10000")
        .where('start_time >= ? AND start_time <= ?', @from_time, @upto_time)



      halfhourlist ||= []
      orderlists.each do |order_list|

        campaign_name = order_list.name #+ " " + order_list.start_time.strftime("%H:%M")
        if order_list.campaign_playlist
          products = ""
          #cats.each do |cat| cat.name end
          if order_list.order_line.present?
            #products = o.order_line.each(&:description)
            #order_list.order_line.each do |ord|
              products << order_list.order_line.description
              #end
          end


          order_time = (order_list.start_time + 300.minutes).strftime("%H:%M")
          halfhourlist << {
            :campaign => campaign_name,
            :products => products,
            :order_time => order_time,
            :order_id => order_list.external_order_no}
        end


      end # end order list
      total_order_nos = orderlists.distinct.count('order_id')
      total_order_value = orderlists.sum(:gross_sales).round(0)
      s_no_i = 1



        employeeunorderlist << {
          :order_date => (DateTime.strptime(@from_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%Y-%m-%d"),
          :time_start => (DateTime.strptime(@from_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%H:%M"),
          :time_end => (DateTime.strptime(@upto_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%H:%M"),
          :total_nos => total_order_nos,
          :total_value => total_order_value,
          :hourlist => halfhourlist
        }

        @employeeorderlist = employeeunorderlist

     end # end of day
  end

  def operator_sales_performance
    @sales_ppo_retail_default = SalesPpoDefault.find(10000).value
    @sales_ppo_transfer_default = SalesPpoDefault.find(10001).value

    @revised_per_day_rate = 0
    @medias = Medium.where(media_group_id: 10000, active: true,media_commision_id: 10000).where("id <> 11200")
    #media_commision_id = 10000 or
    @sno = 1

     for_date = (330.minutes).from_now.to_date
     @from_date = (330.minutes).from_now.to_date

     if params.has_key?(:media_id)
        @media_id =  params[:media_id]
        @media = Medium.find(@media_id)
     end
     if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @or_for_date = for_date.strftime("%Y-%m-%d")
     end
     @to_date = (330.minutes).from_now.to_date
     if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
     end

     if params.has_key?(:revised_per_day_rate)
        @revised_per_day_rate =  params[:revised_per_day_rate].to_i ||= 0
     end

        @hourlist ||= []
        @halfhourlist ||= []
        employeeunorderlist ||= []


        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes
        nos = 0
        total_order_value = 0
        s_no_i = 1
        @serial_no = 1

        if @media_id.blank?
          return
        end

        @daily_charge = @media.daily_charges || 0 if @media.present?
        @days = 0
        @media_total_fixed_cost = 0
        @revised_media_total_fixed_cost = 0
        (@from_date).upto(@to_date).each do |day|
           @media_total_fixed_cost += @media.daily_charges.to_f || 0 if @media.present?
           @days += 1
           @revised_media_total_fixed_cost += @revised_per_day_rate || 0 if @revised_per_day_rate > 0
        end


        ppo_sales = SalesPpo.new
       @employeeorderlist =  ppo_sales.operator_ppos_for_date @from_date, @to_date, @media_id

      #         #byebug
      #        #@employeeorderlist.each {|c| @total_sales_1 += c.total_sale_1, @total_revenue_1 += c.total_revenue_1 }
      #        @employeeorderlist.each {|c|
      #         @total_sales_1 += c.total_sales_1 # @employeeorderlist.sum(:total_sales_1)
      #         @total_revenue_1 += c.total_revenue_1 #  @employeeorderlist.sum(:total_revenue_1)
      #         @total_product_cost_1 += c.total_product_cost_1 #  @employeeorderlist.sum(:total_product_cost_1)
      #         @total_var_cost_1 += c.total_var_cost_1 #  @employeeorderlist.sum(:total_var_cost_1)
      #         @total_refund_1 += c.total_refund_1 #  @employeeorderlist.sum(:total_refund_1)
      #         @total_damages_1 += c.total_product_dam_cost_1 #  @employeeorderlist.sum(:total_product_dam_cost_1)
      #         #@total_expenses_1 = @employeeorderlist.sum(:total_nos_1)
      #         @total_nos_1 += c.total_nos_1 #  @employeeorderlist.sum(:total_nos_1)
      # #
      #         @total_sales_2 += c.total_sales_2 #  @employeeorderlist.sum(:total_sales_2)
      #         @total_revenue_2 += c.total_revenue_2 #  @employeeorderlist.sum(:total_revenue_2)
      #         @total_product_cost_2 += c.total_product_cost_2 #  @employeeorderlist.sum(:total_product_cost_2)
      #         @total_var_cost_2 += c.total_var_cost_2 #  @employeeorderlist.sum(:total_var_cost_2)
      #         @total_refund_2 += c.total_refund_2 #  @employeeorderlist.sum(:total_refund_2)
      #         @total_damages_2 += c.total_product_dam_cost_2 #  @employeeorderlist.sum(:total_product_dam_cost_2)
      #         #@total_expenses_1 = @employeeorderlist.sum(:total_nos_1)
      #         @total_nos_2 += c.total_nos_2 #  @employeeorderlist.sum(:total_nos_2)
      #       }

        #           @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
        #byebug

              @media_name = @media.name || "None" if @media.present?

          respond_to do |format|
            csv_file_name = "#{@media_name}_performance_between_#{@from_date}_ #{@to_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
  end

  def half_hour_performance
    @hbn_media_cost_master = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "half_hour"

     for_date = (330.minutes).from_now.to_date
     @from_date = (330.minutes).from_now.to_date

     if params.has_key?(:time_id)
       @time_id = params[:time_id]
       @time_slot = MediaCostMaster.find(@time_id)
       @start_hr = @time_slot.str_hr
       @start_min = @time_slot.str_min
       @start_total_secs = (@start_hr * 60) + (@start_min)

       @end_hr = @time_slot.end_hr
        if @end_hr == 0 && @time_slot.end_min == 0
          @end_hr = 23
          @end_min = 59
          @end_total_secs = (@end_hr * 60) + (@end_min)
        else
          @end_min = @time_slot.end_min
          @end_total_secs = (@end_hr * 60) + (@end_min)
        end

     end
     if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @or_for_date = for_date.strftime("%Y-%m-%d")
     end
     @to_date = (330.minutes).from_now.to_date
     if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
     end

        # @hourlist ||= []
        #         @halfhourlist ||= []
        employeeunorderlist ||= []

        from_date = for_date.beginning_of_day - 300.minutes
        to_date = for_date.end_of_day - 300.minutes


        nos = 0
        total_order_value = 0
        s_no_i = 1
        @serial_no = 1

       ppo_sales = SalesPpo.new
       @employeeorderlist =  ppo_sales.sales_hour_ppos_for_date @from_date, @to_date, @start_total_secs, @end_total_secs

          # flash[:error] = "This is PRODUCT PERFORMANCE DATA"
          # flash[:notice] = "This is PRODUCT PERFORMANCE DATA"

        respond_to do |format|
          csv_file_name = "Half_hour_performance_from_#{@str_hr}_#{@str_min}_to_#{@end_hr}_#{@end_min}_between_#{@from_date}_ #{@to_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
        end
   ####
  end

  def re_create_ppo

    if params.has_key?(:from_date)
      from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @from_date = (from_date.beginning_of_day - 330.minutes)
    end

    if params.has_key?(:to_date)
      to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      @to_date = to_date.end_of_day - 330.minutes
    end
    sales_ppos = SalesPpo.where("start_time >= ? AND start_time <= ?", @from_date, @to_date)
    

    @product_variant_id = nil
    if params[:product_variant_id].present?
      @product_variant_id = params[:product_variant_id]
      sales_ppos = sales_ppos.where(product_variant_id: @product_variant_id)
    end

    @campaign_playlist_id = nil
    if params[:campaign_playlist_id].present?
      @campaign_playlist_id = params[:campaign_playlist_id]
      sales_ppos = sales_ppos.where(campaign_playlist_id: @campaign_playlist_id)
    end

    if @from_date == nil || @to_date == nil && sales_ppos.blank
      redirect_to sales_ppos_path, error: 'Unable to re-create ppos.'
    end
    #sales_ppos = sales_ppos.distinct('order_id').pluck(:order_id)
    # byebug
      nos = 0

      if @campaign_playlist_id.present? || @product_variant_id.present?
        sales_ppos.each do |ppo|
            order_master = OrderMaster.find(ppo.order_id)
            order_master.delay(:queue => 'hbn sales ppos', priority: 100).add_product_to_campaign_hbn_ppo
            #ppo.delay.change_ppo_product_costs ppo.order_id
           nos =+ 1
        end
      else
        order_masters = OrderMaster.where("orderdate >= ? AND orderdate <= ?", @from_date, @to_date)
        order_masters.each do |ord|
          #new_ppo = SalesPpo.new
          # a synchronised between days and calls all other functions
            ord.delay.delay(:queue => 'hbn sales ppos', priority: 100).add_product_to_campaign_hbn_ppo #ord.id
             #ppo.order_id
           #create_sales_ppo ppo.order_id
            nos =+ 1
           #byebug
        end
      end

    time = nos/60.00
    @return_url = nil
     if params.has_key?(:return_url)
       @return_url = params[:return_url]
       redirect_to @return_url, notice: "The process of recreating #{nos} ppos has is completed."
    else
       redirect_to sales_ppos_path, notice: "The process of recreating #{nos} is complete."
     end
  end
  
  
  def recreate_ppo_for_order_id
    @order_id = nil
    nos = 0
    if params[:order_id].present?
      @order_id = params[:order_id]
       sales_ppos = OrderMaster.where(id: @order_id)
    end
    
    if @order_id == nil && sales_ppos.blank
      redirect_to sales_ppos_path, error: 'Unable to re-create ppos.'
    end
    
    sales_ppos = OrderMaster.where(id: @order_id)
    sales_ppos.each do |ppo|
      #new_ppo = SalesPpo.new
      # a synchronised between days and calls all other functions
        ppo.delay(:queue => 'hbn specific order regenerate', priority: 100).add_product_to_campaign_hbn_ppo 
         #ppo.order_id
       #create_sales_ppo ppo.order_id
        nos =+ 1
       #byebug
    end
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
      redirect_to @return_url, notice: "The process of recreating #{nos} ppos has is completed."
   else
      redirect_to sales_ppos_path, notice: "The process of recreating #{nos} is complete."
    end
  end
  
  
  def recreate_ppo_between_days
    sales_ppos = OrderMaster.where("orderdate >= ? AND orderdate <= ?", @from_date, @to_date)
    sales_ppos.each do |ppo|
      #new_ppo = SalesPpo.new
      # a synchronised between days and calls all other functions
        ppo.add_product_to_campaign_hbn_ppo ppo.id
         #ppo.order_id
       #create_sales_ppo ppo.order_id
        nos =+ 1
       #byebug
    end
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
      redirect_to @return_url, notice: "The process of recreating #{nos} ppos has is completed."
   else
      redirect_to sales_ppos_path, notice: "The process of recreating #{nos} is complete."
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
      :dnis, :city, :state, :mobile_no, :transfer_order_revenue,
      :transfer_order_dealer_price, :commission_on_order)
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
      #10006 => CFO cancelled at origin orders
      #10008 => Returned Order (post shipping) / unclaimed orders
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

      @subtotal = 0
      @shipping = 0
      @total = 0
      @cost = 0
      @revenue = 0

      @serial_no = 1

      @total_sales_1, @total_revenue_1, @total_product_cost_1, @total_var_cost_1, @total_var_on_order_cost_1, @total_fixed_cost_1, @total_refund_1, @total_product_dam_cost_1,@total_pieces_1, @total_nos_1 = 0,0,0,0,0,0,0,0,0,0,0.0
      
       @total_sales_2, @total_revenue_2, @total_product_cost_2, @total_var_cost_2, @total_var_on_order_cost_2, @total_fixed_cost_2, @total_refund_2, @total_product_dam_cost_2,@total_pieces_2, @total_nos_2 = 0,0,0,0,0,0,0,0,0,0,0.0
    end

    def all_return_rates
      @return_rates_0 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 0).order(:no_of_days)
      @return_rates_30 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 30).order(:no_of_days)
      @return_rates_60 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 60).order(:no_of_days)

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
    
    def daily_task_ppo_status
      todaydate = Date.today #Time.zone.now + 330.minutes
      @from_date = todaydate - 7.days #30.days
      @to_date = todaydate
      @daily_task_ppo_status = []

      @pay_u_orders = SalesPpo.where('order_status_id = 10001')

      @pay_u_order_count = @pay_u_orders.distinct.count('order_id')
      @pay_u_order_value = @pay_u_orders.sum(:gross_sales)
      #upto
      (@to_date).downto(@from_date).each do |day|
       #for_date =  Date.strptime(day, "%Y-%m-%d")

      totalorders = OrderMaster.where("TRUNC(orderdate) = ?", day)
      .where('ORDER_STATUS_MASTER_ID > 10002').count

      hbnorders = OrderMaster.where("TRUNC(orderdate) = ?", day)
      .where('ORDER_STATUS_MASTER_ID > 10002').joins(:medium).where("media.media_group_id = 10000").count

       total_ppo_orders = SalesPpo.where('order_status_id > 10002')
       .where("TRUNC(start_time) = ? ", day).distinct.count('order_id')



        @daily_task_ppo_status << {:total_orders => totalorders.to_i,
          :hbn_orders => hbnorders.to_i,
        :for_date =>  day.strftime("%d-%b-%Y"),
        :total_ppo => total_ppo_orders.to_i,
        :difference => (hbnorders - total_ppo_orders).to_i}
      end
    end
  end
