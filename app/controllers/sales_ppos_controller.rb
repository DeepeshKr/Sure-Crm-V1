class SalesPposController < ApplicationController
  before_action { protect_controllers(5) }
  before_action :set_sales_ppo, only: [:show, :edit, :update, :destroy]
  before_action :hbn_fixed_costs, only: [:index ] #, :hourly, :hour_performance, :product_performance, :product_hour_performance, :operator_performance, :show, :ppo_products, :channel]
  before_action :all_cancelled_orders

  # GET /sales_ppos
  # GET /sales_ppos.json
  def index
    @sales_ppos = SalesPpo.order("created_at DESC").paginate(:page => params[:page])

    todaydate = Date.today #Time.zone.now + 330.minutes
    #todaydate = Date.parse(todaydate).strftime('%m/%d/%Y')
    #todaydate =  Date.strptime(todaydate, "%Y-%m-%d")
    @from_date = todaydate - 1.days #30.days
    @to_date = todaydate
    if params.has_key?(:for_date)
          for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
          @from_date = for_date.to_date - 1.days #30.days
          @to_date = for_date.to_date

    # else
    #   return
    end
    @datelist ||= []
    employeeunorderlist ||= []
    @to_date.downto(@from_date).each do |day|
      #byebug
           # day = day - 330.minutes
          @datelist << day.strftime('%y-%b-%d')

          for_date = day # Date.
          @or_for_date = for_date

          @from_date = for_date.beginning_of_day - 330.minutes
          @to_date = for_date.end_of_day - 330.minutes

          orderlist = SalesPpo.all.limit(100)
          .where('TRUNC(start_time) >= ? AND TRUNC(start_time) <= ?', @from_date, @to_date)
          .where(order_status_id: @cancelled_status_id)
          
           #.joins(:medium).where("media.media_group_id = 10000") #.limit(1)

          # #split the fixed cost across the hour
          revenue = 0
          media_var_cost = 0
          product_cost = 0
          gross_sales = 0
          @list_of_orders ||= []

          orderlist.each do |med |
            @list_of_orders << {order_no:  med.order_master.external_order_no,
             time_of_order: med.start_time.strftime('%Y-%b-%d %H:%M:%S')}
            #error loggin

            revenue += med.revenue  ||= 0
            media_var_cost += med.commission_cost ||= 0
            product_cost += med.product_cost ||= 0

          end

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
          :for_date =>  for_date.strftime("%Y-%m-%d"),
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
        @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse


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
