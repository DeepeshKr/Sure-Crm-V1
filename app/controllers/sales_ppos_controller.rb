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
    all_return_rates
    todaydate = Date.today #Time.zone.now + 330.minutes
    @from_date = todaydate - 30.days #30.days
    @to_date = todaydate
    if params.has_key?(:from_date)
        from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = from_date.to_date - 30.days #30.days
        @to_date = from_date.to_date
    end

    @deal_tran = DEALTRAN.where("custref = ?", 3271554)

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
      #nos = (orderlist.count())

      nos = orderlist.distinct.count('order_id') #.count('order_id', :distinct => true)
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

      campaign_playlist_id = params[:campaign_id]
      @campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
      @campaign = Campaign.find(@campaign_playlist.campaignid)

      @page_heading = "PPO Details #{@campaign_playlist.product_variant.name if @campaign_playlist.product_variant}
      for #{@campaign_playlist.for_date.strftime('%d-%b-%Y')} #{@campaign_playlist.start_hr.to_s.rjust(2,'0')}:#{@campaign_playlist.start_min.to_s.rjust(2,'0')}:#{@campaign_playlist.start_sec.to_s.rjust(2, '0')}"

      @order_masters = OrderMaster.where(campaign_playlist_id: campaign_playlist_id)
         .where('ORDER_STATUS_MASTER_ID > 10002')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .order("created_at")

         @all_order_masters = OrderMaster.where(campaign_playlist_id: campaign_playlist_id)
            .where('ORDER_STATUS_MASTER_ID > 10002').count

      @sales_ppos = SalesPpo.where('order_status_id > 10002')
      .where(campaign_playlist_id: campaign_playlist_id)
      .order("start_time")

       @all_ppo_orders = @sales_ppos.distinct.count('order_id')

      # .where.not(order_status_id: @cancelled_status_id)



       ppo_sales = SalesPpo.new

       @open_orders = ppo_sales.show_open_orders campaign_playlist_id
       #campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
       @return_rates = ReturnRate.new
        return_rate = ReturnRate.new
        rate_best_of_threes = return_rate.retail_best_of_three(@campaign_playlist.productvariantid, @campaign.mediumid)
        @quick_return_rates = return_rate.retail_best_of_three(@campaign_playlist.productvariantid, @campaign.mediumid)
        rate_best_of_three = rate_best_of_threes.first

        @to_return_rate = return_rate.transfer_order_default_rate
        @final_return_rate = return_rate.retail_best_shipped_paid_percent(@campaign_playlist.productvariantid, @campaign.mediumid)
        @to_final_return_rate = return_rate.transfer_best_shipped_paid_percent(@campaign_playlist.productvariantid, @campaign.mediumid)

       @retail_sales_all = ppo_sales.ppo_details(campaign_playlist_id, true, false, 100.0, 100.0, "retail")
       @retail_sales_shipped = ppo_sales.ppo_details(campaign_playlist_id, true, false, return_rate.shipped_percent, 0.0, "retail")
       @retail_sales_default = ppo_sales.ppo_details(campaign_playlist_id, true, false, @return_rates.retail_default_rate, 0.0, "retail")
       @retail_sales_3_mo = ppo_sales.ppo_details(campaign_playlist_id, true, false, rate_best_of_three.rate, 0.0, "retail")

       @to_correction = @to_sales_3_mo.correction || 100.0 if @to_sales_3_mo.present?
       # campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results

       @to_sales_all = ppo_sales.ppo_details(campaign_playlist_id, true, false, 0.0, 100.0, "to")
       @to_sales_shipped = ppo_sales.ppo_details(campaign_playlist_id, true, false, 0.0, 80.0, "to")
       @to_sales_default = ppo_sales.ppo_details(campaign_playlist_id, true, false, 0.0, @return_rates.transfer_order_default_rate, "to")
       @to_sales_3_mo = ppo_sales.ppo_details(campaign_playlist_id, false, false, 0.0, @to_final_return_rate.rate_2, "to")

       @sales_all = ppo_sales.ppo_details(campaign_playlist_id, true, false, 100.0, 100.0, "all")
       @sales_shipped = ppo_sales.ppo_details(campaign_playlist_id, true, false, return_rate.shipped_percent, 80.0, "all")
       @sales_default = ppo_sales.ppo_details(campaign_playlist_id, true, false, @return_rates.retail_default_rate, @return_rates.transfer_order_default_rate, "all")
       @sales_3_mo = ppo_sales.ppo_details(campaign_playlist_id, true, false, rate_best_of_three.rate, @to_final_return_rate.rate_2, "all")

      start_hr = @campaign_playlist.start_hr
      start_min = @campaign_playlist.start_min

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
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
    @from_date = (330.minutes).from_now.to_date
    for_date = (330.minutes).from_now.to_date

    @product_variants = ProductVariant.all.order("name").where("activeid = 10000")

   if params.has_key?(:product_variant_id)
    @product_variant_id = params[:product_variant_id]
    @product_variant = ProductVariant.find(@product_variant_id)
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

   ppo_sales = SalesPpo.new
   @employeeorderlist = ppo_sales.sales_product_ppos_for_date @from_date, @to_date, @product_variant_id

   @serial_no += 1

   @report_results = "Searched for dates #{@from_date} to #{@to_date} and nothing found"
   #@employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
    respond_to do |format|
      csv_file_name = "#{@product_variant.name}_performance_between_#{@from_date}_ #{@to_date}.csv"
        format.html

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

  def hour_sales_performance
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
  
  def operator_sales_performance
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
        #media segregation only HBN
        check_from_date = corrected_date_time(to_date, "9", "30")
        check_upto_date = corrected_date_time(to_date, "10", "00")

        nos = 0
        total_order_value = 0
        s_no_i = 1
        @serial_no = 0

           campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", @from_date, @to_date).where(list_status_id: 10000).order("for_date, start_hr, start_min").joins(:campaign) #.limit(15)

           @daily_charge = @media.daily_charges || 0 if @media.present?
           @days = 0
           @media_total_fixed_cost = 0
           @revised_media_total_fixed_cost = 0
           (@from_date).upto(@to_date).each do |day|
              @media_total_fixed_cost += @media.daily_charges.to_f || 0 if @media.present?
              @days += 1
              @revised_media_total_fixed_cost += @revised_per_day_rate || 0 if @revised_per_day_rate > 0
           end

           if @media_id.blank?
             return
           end
           campaign_playlists.each do | playlist |
           orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
           .where(campaign_playlist_id: playlist.id).where(media_id: @media_id)

                revenue = 0
                media_var_cost = 0
                product_cost = 0
                @fixed_cost = playlist.cost
                nos = 0.0
                pieces = 0.0

                orderlist.each do |med |
                  product_cost += med.productcost
                  revenue += med.productrevenue
                  media_var_cost += med.media_commission
                  nos += 1
                  pieces += med.pieces
                end

                total_shipping = orderlist.sum(:shipping)
                total_sub_total = orderlist.sum(:subtotal)
                totalorders = total_shipping + total_sub_total
                #nos = orderlist.count()
                #pieces = orderlist.sum(:pieces)

                nos =  nos * @correction
                pieces = pieces * @correction
                revenue = revenue * @correction
                # #product_cost = product_cost * nos
                product_cost = (product_cost * @correction)
                product_damages = (product_cost * 0.10)
                totalorders = totalorders * @correction
                media_var_cost = media_var_cost * @correction
                refund = totalorders * 0.02

                 if nos == 0
                   divide_nos = 1
                 else
                   divide_nos = nos
                 end
                total_cost = (product_cost + @fixed_cost + product_damages + media_var_cost + refund)
                profitability = ((revenue - total_cost)/ divide_nos).to_i

                ### check if product cost is found in product master
                product_cost_master = 0
                if ProductCostMaster.where(prod: playlist.product_variant.extproductcode).present?
                  product_cost_master = ProductCostMaster.where(prod: playlist.product_variant.extproductcode).first.cost
                end
                row_css = "row-highlight" || nil if totalorders > 0
                employeeunorderlist << {:serial_no => @serial_no,
                  :show =>  playlist.product_variant.name,
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
                :row_css => row_css,
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

              @media_name = @media.name || "None" if @media.present?
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
          respond_to do |format|
            csv_file_name = "#{@media_name}_performance_between_#{@from_date}_ #{@to_date}.csv"
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
      :dnis, :city, :state, :mobile_no, :transfer_order_revenue,
      :transfer_order_dealer_price)
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
    end

    def all_return_rates
      @return_rates_0 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 0).order(:no_of_days)
      @return_rates_30 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 30).order(:no_of_days)
      @return_rates_60 = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 60).order(:no_of_days)

    end
  end
