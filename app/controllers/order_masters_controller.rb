class OrderMastersController < ApplicationController
  before_action { protect_controllers(7) }
  before_action :set_order_master, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_masters = OrderMaster.all.order("id DESC").limit(100)
    respond_with(@order_masters)
  end

  def list
    #<br>      <small>About <%= time_ago_in_words(order_master.orderdate + 330.minutes) %> ago </small>
    @sno = 1
    @employees = Employee.all.order("first_name")
    .joins(:employee_role)
    .where("employee_roles.sortorder > 8")

    if params[:employee_id].present?
      @employee_id = params[:employee_id]
      employee = Employee.find(@employee_id).fullname
      if params[:completed].present?
        # all completed orders only
         if params[:for_date].present?
          for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")

          @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
          .where('TRUNC(orderdate) = ?',for_date)
          .where(employee_id: @employee_id)
          .order("id").paginate(:page => params[:page])
          @orderdesc = "#{@order_masters.count()} orders of #{employee} for #{for_date}"
         else
          @orderdesc = "Recent 500 completed orders of #{employee} "
          @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where(employee_id: @employee_id).limit(500)
          .paginate(:page => params[:page])

         end
      else
         @orderdesc = "Recent 1000 all orders of #{employee} "
          @order_masters = OrderMaster.where(employee_id: @employee_id)
          .order("id DESC").limit(1000).paginate(:page => params[:page])
      end

    elsif params[:completed].present?
      if params[:completed] = 'yes'
        @orderdesc = "Showing Completed 1000 orders"
        @order_masters = OrderMaster.where('external_order_no IS NOT NULL')
        .order("id DESC").limit(1000).paginate(:page => params[:page])
      end
    else
      @orderdesc = "Showing Recent 100 orders"
       @order_masters = OrderMaster.order("id DESC").limit(100)
       .paginate(:page => params[:page])
    end



    respond_with(@order_masters)
  end

  def daily_report
    @today_date = Time.zone.now.to_date.strftime("%Y-%m-%d")
     @sno = 1
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
    if params[:for_date].present?

       @today_date
      #@summary ||= []
      # @or_for_date = params[:for_date]
      for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      @today_date = for_date.strftime("%Y-%m-%d")
      @or_for_date = for_date.strftime("%m-%d-%Y")
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

    elsif params[:from_date].present? && params[:to_date].present?
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      @or_for_date = for_date.strftime("%Y-%m-%d")
      order_masters = OrderMaster.where('TRUNC(orderdate) >= ? AND TRUNC(orderdate) <= ?',from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10002').select(:employee_id).distinct

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

  def show

    alldropdowns
    if @order_master.customer_id.present?
      @customer = Customer.find(@order_master.customer_id)
    end

    @customer_address = CustomerAddress.new

    if @order_master.customer_address_id.present?
      @customer_address = CustomerAddress.find(@order_master.customer_address_id)
    end

    if @order_master.campaign_playlist_id.present?
      @campaign_playlist = CampaignPlaylist.find(@order_master.campaign_playlist_id)
    end

    @order_lines = OrderLine.where(orderid: @order_master.id)
    @order_line = OrderLine.new
    @order_line.orderid = @order_master.id
    @customer_credit_cards = CustomerCreditCard.where(customer_id: @order_master.customer_id)
    @customer_credit_card = CustomerCreditCard.new
    @customer_credit_card.customer_id = @order_master.customer_id
    if @customer_credit_cards.present?
      @customer_credit_card = @customer_credit_cards.last
    end

    respond_with(@order_master, @customer, @customer_address, @order_line, @order_lines, @customer_credit_card)


  end
 
  def detailed_search
    @btn1 = "btn btn-default"
    @btn2 = "btn btn-default"
    @btn3 = "btn btn-default"
    @cancelled_status_id = [10040, 10006, 10008]
    @sno = 1
    @mobile = nil
    @emailid = nil
    @ordersearch = "Please search for any of the above details!"
    if params[:mobile].present?
        @mobile = params[:mobile]
        customers = Customer.where('mobile = ? OR alt_mobile = ?', @mobile, @mobile).pluck("id")
        customer_addresses = CustomerAddress.where('telephone1 = ? OR telephone2 = ?', @mobile, @mobile).pluck("id")
        @order_masters = OrderMaster.where("customer_address_id in (?) or customer_id in (?) or mobile = ?",customer_addresses,customers, @mobile)
        .order("orderdate DESC").paginate(:page => params[:page])
    elsif params[:emailid].present?
        @emailid = params[:emailid]
        customers = Customer.where('emailid = ? OR alt_emailid = ?', @emailid, @emailid).pluck("id")
        @order_masters = OrderMaster.where(customer_id: customers)
        .order("orderdate DESC")
        .paginate(:page => params[:page])
    elsif params[:order_id].present?
        @order_id = params[:order_id]
        @order_masters = OrderMaster.where('id = ? or original_order_id = ?', @order_id, @order_id)
        .order("orderdate DESC").paginate(:page => params[:page])

     elsif params[:calledno].present?
        @calledno = params[:calledno]
        @order_masters = OrderMaster.where(calledno: @calledno).order("orderdate DESC").paginate(:page => params[:page])

    end
    
    status = params[:type_id].to_i
    case status # a_variable is the variable we want to compare
      when 10000    #compare to 1
        @btn1 = "btn btn-success"
        @message_details = "Showing all orders"
        @order_masters = @order_masters.where('ORDER_STATUS_MASTER_ID >= 10000')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      when 10001    #compare to 2
        @btn2 = "btn btn-success"
         @message_details = "Showing all Processed"
         @order_masters = @order_masters.where('ORDER_STATUS_MASTER_ID > 10000')
           .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      else
        @message_details = "Wrong Selection made"
    end
  end
  
  def online_search
    @limit = 250
    @sno = 1
    @from_date = (330.minutes).from_now.to_date
    @to_date = (330.minutes).from_now.to_date
    if params.has_key?(:from_date)
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
    end
    if params.has_key?(:to_date)
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
    end
    if params[:calledno].present?
        @calledno = params[:calledno]
    end
    if @from_date.blank? || @to_date.blank? || @calledno.blank?
      return
    end
    @order_masters = OrderMaster.where(calledno: @calledno)
        .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .where('external_order_no IS NOT NULL')
        .order("orderdate DESC")
        .paginate(:page => params[:page])
        # .where.not('ORDER_STATUS_MASTER_ID IN (10040, 10006, 10008)')
        # begin
#           @trans_details =  TransDetails.where(order_no: @order_masters_order_nos).limit(@limit).paginate(:page => params[:page])
#           rescue StandardError=>e
#             @error_message = "Unable to pull the data from hbn.telebrandsindia.com, got this error #{e}, try again!"
#           else
#             @trans_details
#          end
        #
        # json["records"].each do |o|
 #          # do something
 #          @unorderlist << {:officename => o["officename"],
 #            :pincode => o["pincode"],
 #            :deliverystatus => o["Deliverystatus"],
 #            :divisionname => o["divisionname"],
 #            :circlename => o["circlename"],
 #            :taluk => o["Taluk"],
 #            :districtname => o["Districtname"],
 #            :regionname => o["regionname"],
 #            :statename => o["statename"]}
 #        end
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

  end
  
  def online_one_day_search
    @limit = 250
    @sno = 1
    @from_date = (330.minutes).from_now.to_date
    
    if params.has_key?(:from_date)
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
    end
  
    if @from_date.blank? 
      return
    end
    @order_masters = OrderMaster.where('TRUNC(orderdate) = ?', @from_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .order("orderdate DESC")
        .paginate(:page => params[:page])
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")

  end
  
  def online_pending_search
    #data from TransDetails
    @limit = 250
    @sno = 1
    @from_date = (330.minutes).from_now.to_date
    @to_date = (330.minutes).from_now.to_date
    if params.has_key?(:from_date)
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
    end
    if params.has_key?(:to_date)
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
    end
    
    if @from_date.blank? || @to_date.blank? 
      return
    end
    @hbn_trans_details = TransDetails.where('OrderNo IS NULL')
        .where('(OrderDate) >= ? and (OrderDate) <= ?', @from_date, @to_date)
        .paginate(:page => params[:page])
        
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

  end
  
  def online_add_to_order
     if params.has_key?(:order_id)
      @tran_details = TransDetails.new
      order_id = params[:order_id]
      
      @tran_details.update_customer_order_list order_id
      
      if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      end
      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end
      
      redirect_to order_masters_online_pending_search_path(:from_date => @from_date, :to_date => @todate)
      
     end
  end
  #get 'custordersearch' => 'order_masters#search'
  def search
     @ordersearchresults = "Please search for Order, Results across Ordering, Processing and Dispatch"
     @vppsearch = "Please search for Order, Results across Ordering, Processing and Dispatch"
     @dealtransearch = "Please search for Orders in Transfer Orders"

     if params.has_key?(:manifest)
       @manifest = params[:manifest]
       vpp_search = VPP.where(manifest: @manifest) #.where(custref: @ordernum)
       if vpp_search.present?
         #redirect_to custordersearch_path(:order_id => @order_id)
         custref = vpp_search.first.custref
         redirect_to custordersearch_path(:ordernum => vpp_search.first.custref)
       else
         flash[:error] = "The manifest does not exist!"
       end
     end

     if params[:ordernum].present?
       @ordernum = params[:ordernum]
       @custdetails = CUSTDETAILS.where("ORDERNUM = ?", @ordernum)
       @ordersearchresults = "No Results found in processing search #{@ordernum}"
       @vppsearch = "No results found in Dispatch, we searched order number #{@ordernum}"
       #if @custdetails.present?
         order_masters = OrderMaster.where(external_order_no: @ordernum)
         if order_masters.present?
           #if @order_master.customer_address_id.present?
             @customer_address = CustomerAddress.find(order_masters.first.customer_address_id)
             @order_master = order_masters.first
             @order_lines = OrderLine.where(orderid: @order_master.id).order("id")
           #end
         end
        
         @sales_ppos = SalesPpo.where(:external_order_no => @ordernum)
         .order("start_time")
         #custref related to
        # if VPP.where(custref: @ordernum).present?
           @vpp = VPP.where(custref: @ordernum)

           if @vpp.present?
             @manifest = @vpp.first.manifest
           end
        # end

         # if DEALTRAN.where(custref: @ordernum).present?
           @dealtran = DEALTRAN.where(custref: @ordernum)
         #end
        

       end
     #end
  end
   # get 'order_masters_review' => 'order_masters#review'
  def review
     @return_url = request.original_url
    if params.has_key?(:order_id)
     @order_id = params[:order_id]
     @order_master = OrderMaster.find(@order_id)
     
     @order_lines_regular = OrderLine.where(orderid: @order_id)
      .joins(:product_variant)
      .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

   @order_lines_basic = OrderLine.where(orderid: @order_id)
   .joins(:product_variant)
   .where('product_variants.product_sell_type_id = ?', 10040)

   @order_lines_common = OrderLine.where(orderid: @order_id)
   .joins(:product_variant)
   .where('product_variants.product_sell_type_id = ?', 10001)

   @order_lines_free = OrderLine.where(orderid: @order_id)
   .joins(:product_variant)
   .where('product_variants.product_sell_type_id = ?', 10060)
   
     #sms
     @message_on_orders = MessageOnOrder.where(message_type_id: 10000, order_id: @order_id).order("id DESC")
    
     #payumoney
     @message_on_pay_u_orders = MessageOnOrder.where(message_type_id: 10020, order_id: @order_id)
     @payumoney_details = PayumoneyDetail.where(orderid: @order_id)
     #ppo
     @regenerate_ppo = "Regenerate PPO for order id #{@order_id}"
     @sales_ppos = SalesPpo.where(:order_id => @order_id).order("start_time")
     
     @page_trails = PageTrail.where(order_id: @order_id).order(:created_at)
     @interaction_masters = InteractionMaster.where("orderid = ? or mobile = ?", @order_id, @order_master.mobile).order(:created_at)
     
     begin
       # do something 
       
       @trans_details =  TransDetails.where("OrderNo is not null").where(order_no: @order_master.external_order_no)
     
     rescue ActiveRecord::RecordNotFound
       # handle not found error
       flash[:success] = "No details found to show results (Date field in_date) "
       return
     rescue ActiveRecord::ActiveRecordError
       # handle other ActiveRecord errors
       flash[:success] = "No details found to show results (Date field in_date) "
       return
     rescue # StandardError
       # handle most other errors
       flash[:success] = "No details found to show results (Date field in_date) "
       return
     rescue Exception
       # handle everything else
       flash[:success] = "No details found to show results (Date field in_date) "
       return
     end
     

   else
     return detailedordersearch_path
   end
     
  end
  
  def new
    @order_master = OrderMaster.new
    respond_with(@order_master)
  end


  def edit
  end

  def create
    @order_master = OrderMaster.new(order_master_params)
    @order_master.save
    respond_with(@order_master)
  end

  def update
    @order_master.update(order_master_params)
    respond_with(@order_master)
  end

  # def destroy
 #    @order_master.destroy
 #    respond_with(@order_master)
 #  end

  private
  def alldropdowns
      @statelist = State.all
      @productvariantlist = ProductVariant.where('activeid = ?',  1)
           .joins(:product_master).where("product_masters.productactivecodeid = ?", 1)
  end


    def set_order_master
      @order_master = OrderMaster.find(params[:id])
    end

    def order_master_params
      params.require(:order_master).permit(:orderdate, :employeecode, :employee_id,
        :customer_id, :customer_address_id, :billno, :external_order_no, :pieces,
        :subtotal, :taxes, :shipping, :codcharges, :total, :order_status_master_id,
        :orderpaymentmode_id, :campaign_playlist_id, :notes, :order_source_id,
        :media_id, :corporate_id, :order_for_id, :userip, :sessionid, :calledno,
        :original_order_id, :promotion_id)
    end
end
# create_table "order_masters", force: :cascade do |t|
#   t.datetime "orderdate"
#   t.string   "employeecode"
#   t.integer  "employee_id",            precision: 38
#   t.integer  "customer_id",            precision: 38
#   t.integer  "customer_address_id",    precision: 38
#   t.string   "billno"
#   t.string   "external_order_no"
#   t.integer  "pieces",                 precision: 38
#   t.decimal  "subtotal"
#   t.decimal  "taxes"
#   t.decimal  "shipping"
#   t.decimal  "codcharges"
#   t.decimal  "total"
#   t.integer  "order_status_master_id", precision: 38
#   t.integer  "orderpaymentmode_id",    precision: 38
#   t.integer  "campaign_playlist_id",   precision: 38
#   t.text     "notes"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "calledno"
#   t.integer  "order_source_id",        precision: 38
#   t.integer  "media_id",               precision: 38
#   t.integer  "corporate_id",           precision: 38
#   t.integer  "order_for_id",           precision: 38
#   t.string   "userip"
#   t.string   "sessionid"
#   t.string   "mobile"
#   t.integer  "original_order_id",      precision: 38
#   t.integer  "promotion_id",           precision: 38
#   t.string   "city"
#   t.string   "pincode"
#   t.integer  "order_last_mile_id",     precision: 38
#   t.integer  "order_final_status_id",  precision: 38
#   t.decimal  "g_total",                precision: 12, scale: 2
#   t.integer  "weight_kg",              precision: 38
#   t.integer  "interaction_master_id",  precision: 38
#   t.datetime "process_date"
#   t.datetime "ship_date"
#   t.datetime "cancelled_date"
#   t.datetime "paid_date"
#   t.datetime "refund_date"
#   t.datetime "returned_date"
# end