class SalesPposController < ApplicationController
  before_action { protect_controllers(5) }
  before_action :set_sales_ppo, only: [:show, :edit, :update, :destroy]
  before_action :hbn_fixed_costs, only: [:index ] #, :hourly, :hour_performance, :product_performance, :product_hour_performance, :operator_performance, :show, :ppo_products, :channel]
  before_action :all_cancelled_orders

  # GET /sales_ppos
  # GET /sales_ppos.json
  def index
    @sno = 1

    todaydate = Date.today #Time.zone.now + 330.minutes
    #todaydate = Date.parse(todaydate).strftime('%m/%d/%Y')
    #todaydate =  Date.strptime(todaydate, "%Y-%m-%d")
    @from_date = todaydate - 1.days #30.days
    @to_date = todaydate
    if params.has_key?(:from_date)
          from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
          @from_date = from_date.to_date - 2.days #30.days
          @to_date = from_date.to_date

    # else
    #   return
    end
    
     @or_for_date = @to_date
    #@datelist ||= []
    employeeunorderlist ||= []
    
    @to_date.downto(@from_date).each do |day|
      #byebug
          #day = Date.strptime(day, "%Y-%m-%d %H:%M:%S") #day.strftime('%Y-%b-%d')
          #@datelist << day.strftime('%Y-%b-%d')

         
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
          :for_date => @or_for_date,
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

        @from_date = for_date.beginning_of_day - 300.minutes
        @to_date = for_date.end_of_day - 300.minutes
        #media segregation only HBN

        nos = 0
        total_order_value = 0
        #start loop

        (@from_date.to_datetime.to_i .. @to_date.to_datetime.to_i).step(30.minutes) do |date|

         halfhourago = Time.at(date - 30.minutes)

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
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
  
  
  # GET /sales_ppos/1
  # GET /sales_ppos/1.json
  def show
  end

  # GET /sales_ppos/new
  def new
    @sales_ppo = SalesPpo.new
  end

  # GET /sales_ppos/1/edit
  def edit
  end

  # POST /sales_ppos
  # POST /sales_ppos.json
  def create
    @sales_ppo = SalesPpo.new(sales_ppo_params)

    respond_to do |format|
      if @sales_ppo.save
        format.html { redirect_to @sales_ppo, notice: 'Sales ppo was successfully created.' }
        format.json { render :show, status: :created, location: @sales_ppo }
      else
        format.html { render :new }
        format.json { render json: @sales_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_ppos/1
  # PATCH/PUT /sales_ppos/1.json
  def update
    respond_to do |format|
      if @sales_ppo.update(sales_ppo_params)
        format.html { redirect_to @sales_ppo, notice: 'Sales ppo was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_ppo }
      else
        format.html { render :edit }
        format.json { render json: @sales_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_ppos/1
  # DELETE /sales_ppos/1.json
  def destroy
    @sales_ppo.destroy
    respond_to do |format|
      format.html { redirect_to sales_ppos_url, notice: 'Sales ppo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_ppo
      @sales_ppo = SalesPpo.find(params[:id])
    end

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
      #

    end
    def all_cancelled_orders
      @cancelled_status_id = [10040, 10006, 10008]
      #10040 => tranfer order cancelled
      #10006 => CFO and cancelled orders / unclaimed orders
      #10008 => Returned Order (post shipping)
      #session[:cancelled_status_id] = @cancelled_status_id
    end
  end
