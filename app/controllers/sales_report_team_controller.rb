class SalesReportTeamController < ApplicationController
  before_action { protect_controllers(9) }
   respond_to :html
   before_action :drop_downs, only: [:city, :update, :destroy, :deleteupsell]
   before_action :all_cancelled_orders
   before_action :use_from_to_date

  def index
   @from_date = (Date.current + 330.minutes).strftime("%Y-%m-%d")
  end

  def show_wise
        @searchaction = "show_wise"

        if params[:from_date].present?
          for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
          @from_date = for_date.beginning_of_day + 330.minutes
        end
        #use_from_to_date 0
        if @from_date == nil
          return
        end

         @sno = 1

        @total_nos = 0
        @total_pieces = 0
        @total_sales = 0

        #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []

        #@for_date = @campaign.startdate
       campaign_playlists =  CampaignPlaylist
       .where("TRUNC(for_date) = ? ", for_date)
       .order(:start_hr, :start_min, :start_sec)
       .where(list_status_id: 10000) #.limit(10)

         #return if campaign_playlists.blank?

      campaign_playlists.each do | playlist |
       orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
       .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
       .where(campaign_playlist_id: playlist.id)

        totalorders = orderlist.sum(:total)
           nos = orderlist.count()
         pieces = orderlist.sum(:pieces)
          employeeunorderlist << {:id => playlist.id,
            :for_date => playlist.for_date,
            :show =>  playlist.product_variant.name,
          :campaign_id => playlist.id,
          :prod => playlist.product_variant.extproductcode,
           :pieces => pieces,
          :nos => nos,
          :at_time => playlist.starttime,
          :end_time => playlist.playlist_group_end_time,
          :total => totalorders}
      end

    #this is for date on the view
    @from_date = (@from_date).strftime("%Y-%m-%d")
    #@to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

    @header_text = "HBN Show response for #{@from_date}"
    @employeeorderlist = employeeunorderlist
    csv_file_name = "HBN-Show-response-for-#{@from_date}"   
        
    respond_to do |format|
        format.html
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
          headers['Content-Type'] ||= 'text/csv'
        end
    end

  end

  def agent_order
    @searchaction = "agent_order"
      @sno = 1
      @total_pay_u_orders, @total_pay_u_value, @total_ccorders,  @total_ccvalue,  @total_codorders,  @total_codvalue,  @total_nos, @total_total = 0,0,0,0,0,0,0,0
      #@months = [['-', '']](1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
     use_from_to_date 1
     if @from_date == nil
       return
     end
     
     order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
     .where('ORDER_STATUS_MASTER_ID > 10000')
     .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id).order(:orderdate)
     
     @first_order_at = order_masters.first.orderdate + 330.minutes
     @last_order_at =  order_masters.last.orderdate + 330.minutes
     
      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10000')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .select(:employee_id).distinct
      
      
      #for_date =  Date.strptime(, "%Y-%m-%d")
      @orderdate = "Searched for #{(@from_date + 330.minutes).strftime("%Y-%m-%d")} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id

        name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)

        orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        
       
        
        timetaken = orderlist.sum(:codcharges)
        pay_u_value = orderlist.where(orderpaymentmode_id: 10080).sum(:total)
        pay_u_orders = orderlist.where(orderpaymentmode_id: 10080).count()
        
        
        ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
        ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
        

        codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
        codorders = orderlist.where(orderpaymentmode_id: 10001).count()
        

        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :employee => name, :for_date =>  @or_for_date,
          :nos => noorders, :pay_u_orders => pay_u_orders, :pay_u_value => pay_u_value,
          :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

      #this is for date on the view
      @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
      @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

        respond_to do |format|
        csv_file_name = "employee_sales_#{@or_for_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

  end
  
  def agent_order_list
    
    if params[:employee_id].present?
      @employee_id = params[:employee_id]
      @employee = Employee.find(@employee_id).fullname
    end
    if params[:for_date].present?
       @for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
    end
    
    @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
    .where('TRUNC(orderdate) = ?',@for_date)
    .where(employee_id: @employee_id)
    .order("id").paginate(:page => params[:page])
    @orderdesc = "#{@order_masters.count()} orders of #{@employee} for #{@for_date}"
    
    @pay_u_order_ids = @order_masters.where(orderpaymentmode_id: 10080).pluck(:id)
    @codorders_ids = @order_masters.where(orderpaymentmode_id: 10001).pluck(:id)
    @ccorders_ids = @order_masters.where(orderpaymentmode_id: 10000).pluck(:id)
    
  end
  
  def pay_u_orders
      #     #media segregation only HBN
      #     #media_segments
      #     @sno = 1
      #
      @btn1 = "btn btn-default"
      @btn2 = "btn btn-default"
      @btn3 = "btn btn-default"
      @btn4 = "btn btn-default"
      use_from_to_date 1
      if @from_date == nil
        return
      end

      #10060 is the payumoney payment source and 10001 status is follow up
      # .where(ORDER_STATUS_MASTER_ID: 10001)
      order_masters = OrderMaster.where(order_source_id: 10060)
      .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).order("orderdate DESC") #.limit(20)


      if params.has_key?(:show)
        @show = params[:show]
        case @show # a_variable is the variable we want to compare
          when "all"    #compare to 1
            @btn1 = "btn btn-success"
            @message_details = "All Pay U Orders"

          when "pending"    #compare to 1
            @btn2 = "btn btn-success"
            @message_details = "Pending Orders"
            order_masters = order_masters.where("order_status_master_id < 10003")
          when "pay_u_paid"    #compare to 1
            @btn3 = "btn btn-success"
            @message_details = "Pay U Paid"
            order_masters = order_masters.where(orderpaymentmode_id: 10080).where("order_status_master_id > 10002")
          when "pay_u_cod"    #compare to 1
            @btn4 = "btn btn-success"
            @message_details = "Converted to COD"
            order_masters = order_masters.where(orderpaymentmode_id: 10001).where("order_status_master_id > 10002")
        end
      end

      @orderdate = "Pay u money Orders between #{@from_date} and #{@to_date} found #{order_masters.count} orders order are processed to COD after 24 hours!"

      # =>
      @sno = 1
          employeeunorderlist ||= []
          num = 1
          order_masters.each do |o|
            e = o.employee_id
            name = Employee.find(e).first_name ||= "NA" #if Employee.find(e).first_name.present?)
            channel = Medium.find(o.media_id).name ||= "NA" if o.media_id.present?
            customer_name = Customer.find(o.customer_id).fullname ||= "NA" if o.customer_id.present?
            main_products = ""
            upsell_products = ""

            main_product_type_id = 10000

            #cats.each do |cat| cat.name end
            if o.order_line.present?
              o.order_line.where(orderid: o.id).joins(:product_variant)
                    .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).each do |ord| main_products << " #{ord.product_variant.extproductcode}"  end
              #products = o.order_line.each(&:description)
              o.order_line.where(orderid: o.id).joins(:product_variant)
                    .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).each do |ord| upsell_products << " #{ord.product_variant.extproductcode} |"  end
            end
            merchantTransactionId = "NA"
             
            merchantTransactionId = PayumoneyDetail.find_by_orderid(o.id).merchantTransactionId if PayumoneyDetail.find_by_orderid(o.id)
            # <%= @payumoney_detail.merchantTransactionId %>
            
           # paid_status = "#{o.orderpaymentmode.name}"

            employeeunorderlist << {:total => o.total_value,
            :order_id => o.id,
            :order_no => (o.external_order_no || "NA" if o.external_order_no.present?),
            :status => o.orderpaymentmode.name,
            :order_status => o.order_status_master.name,
            :pay_u_ref_id => merchantTransactionId,
            :sno => num,
            :employee => name,
            :mobile => o.mobile,
            :customer => customer_name,
            :orderdate =>  (o.orderdate  + 330.minutes).strftime("%Y-%m-%d"),
            :ordertime =>  (o.orderdate  + 330.minutes).strftime("%H:%M"),
            :main_products => main_products,
            :upsell_products => upsell_products,
            :city => o.city ,
            :channel => channel,
            :order_lines => OrderLine.where(orderid: o.id).order(:id),
            :pieces => o.pieces,
            :no_of =>  num}
             num += 1
          end
          # CSV.generate_line([c[:sno], c[:mobile], c[:employee], c[:order_date], c[:customer], c[:phone], c[:product], c[:total], c[:address], c[:city], c[:total]]).html_safe.strip


           @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
           @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

         #
         @employeeorderlist = employeeunorderlist
          respond_to do |format|
            csv_file_name = "pay_u_money_orders_from_#{@from_date}_to_#{@to_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
              end
          end #end csv


  end #end function

  def agent_common_upsell_order
     product_type_id = 10001
    @searchaction = "agent_common_upsell_order"
     @sno = 1

        #@months = [['-', '']](1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
        #@order_master.orderpaymentmode_id == 10000 #paid over CC
        #@order_master.orderpaymentmode_id == 10001 #paid over COD
       use_from_to_date 1
       if @from_date == nil
         return
       end
        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .select(:employee_id).distinct

               employeeunorderlist ||= []
        num = 1
        order_masters.each do |o|
          e = o.employee_id

          name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)

          # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
    #       .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
    #       .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)

          orderlist = OrderLine.joins(:order_master).where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
          .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
          .where("order_masters.employee_id = ?", e)
          .where.not("order_masters.ORDER_STATUS_MASTER_ID IN (?)", @cancelled_status_id)
          .joins(:product_variant).where("product_variants.product_sell_type_id = ?", product_type_id)

          timetaken = orderlist.sum(:codcharges)
          pay_u_value = orderlist.where("order_masters.orderpaymentmode_id = 10080").sum(:total)
          pay_u_orders = orderlist.where("order_masters.orderpaymentmode_id = 10080").count()

          ccvalue = orderlist.where("order_masters.orderpaymentmode_id = 10000").sum(:total)
          ccorders = orderlist.where("order_masters.orderpaymentmode_id = 10000").count()

          codvalue = orderlist.where("order_masters.orderpaymentmode_id = 10001").sum(:total)
          codorders = orderlist.where("order_masters.orderpaymentmode_id = 10001").count()

          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
             :id => e, :employee => name, :for_date =>  @or_for_date,
            :nos => noorders, :pay_u_orders => pay_u_orders, :pay_u_value => pay_u_value,
            :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end
          @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @orderdate = "Common Upsell orders between #{@from_date} and #{@to_date} found #{order_masters.count} agents!"

          respond_to do |format|
          csv_file_name = "employee_sales_#{@or_for_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end

  end

  def agent_basic_upsell_order
   product_type_id = 10040

    @searchaction = "agent_basic_upsell_order"
      @sno = 1

      #@months = [['-', '']](1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
     use_from_to_date 1
     if @from_date == nil
       return
     end
      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10000')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .select(:employee_id).distinct

        employeeunorderlist ||= []
      num = 1
      order_masters.each do |o|
        e = o.employee_id

        name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)

        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        #       .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        #       .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)

        orderlist = OrderLine.joins(:order_master).where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
        .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where("order_masters.employee_id = ?", e)
        .where.not("order_masters.ORDER_STATUS_MASTER_ID IN (?)", @cancelled_status_id)
        .joins(:product_variant).where("product_variants.product_sell_type_id = ?", product_type_id)

        timetaken = orderlist.sum(:codcharges)
        pay_u_value = orderlist.where("order_masters.orderpaymentmode_id = 10080").sum(:total)
        pay_u_orders = orderlist.where("order_masters.orderpaymentmode_id = 10080").count()

        ccvalue = orderlist.where("order_masters.orderpaymentmode_id = 10000").sum(:total)
        ccorders = orderlist.where("order_masters.orderpaymentmode_id = 10000").count()

        codvalue = orderlist.where("order_masters.orderpaymentmode_id = 10001").sum(:total)
        codorders = orderlist.where("order_masters.orderpaymentmode_id = 10001").count()

        totalorders = orderlist.sum(:total)
        noorders = orderlist.count()
        employeeunorderlist << {:total => totalorders,
           :id => e, :employee => name, :for_date =>  @or_for_date,
          :nos => noorders, :pay_u_orders => pay_u_orders, :pay_u_value => pay_u_value,
          :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

      #this is for date on the view
      @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
      @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
      @orderdate = "Basic Upsell orders between #{@from_date} and #{@to_date} found #{order_masters.count} agents!"

        respond_to do |format|
        csv_file_name = "employee_sales_#{@or_for_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

  end

  def not_completed

  end

  def products_sold
    @sno = 1
      @ordersearch = "No Products sold for the period / day"

    if params[:from_date].present?

        product_name = " "
        use_from_to_date 1
        if @from_date == nil
          @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
          @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
          return
        end
        sold_product_list ||= []
        # like ? ", "#{@telephone}%"
        if params.has_key?(:prod)
          @prod = params[:prod].upcase
          @product_lists = ProductList.where("upper(extproductcode) like ?", "#{@prod}%" )
          if @product_lists.blank?
            @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
            @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
            
            return flash[:errors] = "No prod details found when searched for #{@prod}%!"
          end
          @product_list_ids = @product_lists.pluck(:id) if @product_lists.present?
          sold_product_list = OrderLine.where('order_lines.orderdate >= ? and order_lines.orderdate <= ?', @from_date, @to_date)
          .where(product_list_id: @product_list_ids).joins(:order_master)
          .where('ORDER_MASTERS.ORDER_STATUS_MASTER_ID > 10000')
          .joins(:order_master => :medium).where("media.media_group_id = 10000")
          #.where.not('order_masters.ORDER_STATUS_MASTER_ID IN (10040, 10006, 10008)')#.limit(10)
          #.uniq.pluck(:orderid)
          product_name = @product_lists.first.name

           @order_lines_csv ||= []
                sold_product_list.each do |o|
                  @order_lines_csv << {:order_no => o.order_master.external_order_no,
                :ref_no => o.orderid, :order_date =>  (o.order_master.orderdate + 330.minutes).strftime('%d-%b-%Y'),
                :status => o.order_master.order_status_master.name,
                :customer => o.order_master.customer.name,
                :mobile => o.order_master.mobile,
                :city => o.order_master.customer_address.city + " " + o.order_master.customer_address.pincode,
                :state => o.order_master.customer_address.state,
                :product => o.product_variant.name,
                :total => o.subtotal}
              end

         @order_lines = sold_product_list #.order("orderdate")

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

          respond_to do |format|
            csv_file_name = "#{product_name}_sold_#{@from_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
              end
          end

        end

        #@order_masters = OrderMaster.where(id: sold_product_list)
     end
  end
  
  def showproducts
    @btn1 = "btn btn-default"
    @btn2 = "btn btn-default"
    @btn3 = "btn btn-default"
    @sno = 1
    show_products
  end
  
  def disposition_report
    if params[:from_date].present?
      #@summary ||= []
      @or_for_date = params[:from_date]
      for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @from_date = for_date.beginning_of_day - 330.minutes  
      @to_date = for_date.end_of_day - 330.minutes

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
        @to_date = @to_date.end_of_day - 330.minutes
      end
      @to_date = @to_date.end_of_day - 330.minutes
    end
    
    if @from_date == nil
      @from_date = (Date.current + 330.minutes).strftime("%Y-%m-%d")
      @to_date = (Date.current + 330.minutes).strftime("%Y-%m-%d")
      return
    end
    
    interaction_masters = InteractionMaster.where('created_at >= ? AND created_at <= ?', @from_date, @to_date).order(:created_at)
    
    @sno = 1
      employeeunorderlist ||= []
      dnis = "NA"
      num = 1
      ######
      #######
      interaction_masters.each do |inm|
        product_list = "" # ||= []
        customer_name = inm.customer.fullname || "NA" if inm.customer
        name = Employee.find(inm.employee_id).first_name || "NA" if inm.employee_id.present?
        products = ""
        order_time = "NA"
        order_id = inm.orderid if inm.orderid
            #cats.each do |cat| cat.name end
      if inm.orderid.present?

        order_masters = OrderMaster.find(inm.orderid)
        dnis = order_masters.calledno
        city = order_masters.city ||= "NA"
        total = order_masters.g_total
        channel = Medium.find(order_masters.media_id).name ||= "NA" if order_masters.media_id
    
        @add_on_replacements = ProductMasterAddOn.where("activeid = 10000 AND replace_by_product_id IS NOT NULL").pluck(:product_list_id)
           
        
        if order_masters.order_line.present?
          #@order_lines_regular =  order_masters.order_line
          @order_lines_regular = OrderLine.where(orderid: inm.orderid).joins(:product_variant)
                        .where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_LIST_ID in (?)', 10000, @add_on_replacements)
          @order_lines_regular.each do |ord|
            product_list << ord.product_list.extproductcode
          end
        end
        
        product_list = product_list.gsub(/\s+/, '') if !product_list.nil?
        product_list = product_list.gsub(/&quot;/, '') if !product_list.nil?
        order_time = (order_masters.created_at + 330.minutes).strftime("%Y-%m-%d %H:%M")
      end
        
          employeeunorderlist << {:total => total,
            :dnis => dnis,
          :sno => num,
          :employee => name,
          :mobile => inm.mobile,
          :customer => customer_name,
          :order_time => (inm.created_at + 330.minutes).strftime("%H:%M %p"),
          :on_date =>  (inm.created_at + 330.minutes).strftime("%Y-%m-%d"),
          :products => product_list,
          :city => city,
          :order_id => order_id,
          :channel => channel,
          :disposition => inm.interaction_category.name,
          :no_of =>  num}
           num += 1
      end # end loop
   
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
    
    @orderdate = "Disposition between #{@from_date} and #{@to_date} found #{interaction_masters.count} records!"
       #
   @employeeorderlist = employeeunorderlist
    respond_to do |format|
      csv_file_name = "disposition_report_#{@from_date}_to_#{@to_date}.csv"
        format.html
        format.csv do
          headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
          headers['Content-Type'] ||= 'text/csv'
        end
    end #end csv
  

  end
  
  private

  def shows_between
      for_date = (330.minutes).from_now.to_date

      if params.has_key?(:for_date)
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      end

      #media segregation only HBN
      # media_segments

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

  def show_products
    @btn1 = "btn btn-info"
    @btn2 = "btn btn-info"
    @btn3 = "btn btn-info"
    @show = "all"
     #@summary ||= []
      @from_date = Date.current - 7.days #30.days
     @to_date = Date.current
     if params[:from_date].present?
     #     #@summary ||= []
         @orderdate =  "Please select a date to generate the report"
         for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        #@summary ||= []
        @or_for_date = params[:from_date]
        @to_date = for_date.end_of_day - 330.minutes
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        #@from_date = for_date.beginning_of_day - 330.minutes
        product_name = " "
        from_date = @from_date.beginning_of_day - 330.minutes
        to_date = @from_date.end_of_day - 330.minutes
        if params.has_key?(:to_date)
           @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
           to_date = @to_date.end_of_day - 330.minutes
        end
         @orderdate = params[:for_date]
           for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")


         @show_date = for_date

        #media segregation only HBN
        # media_segments

        @order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10000')
          .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders)
        .select(:id).distinct

        @order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001)
        .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

        @order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000)
        .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

        @order_masters_payu = OrderMaster.where(orderpaymentmode_id: 10080)
        .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        .where('ORDER_STATUS_MASTER_ID > 10000')
        .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

         if params.has_key?(:start_time) && params.has_key?(:end_time)
          start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M")
          end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M")

          @Show_start_time = start_time.strftime("%H:%M")
          @Show_end_time = end_time.strftime("%H:%M")


          @order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
          .where('ORDER_STATUS_MASTER_ID > 10000').where('ORDER_STATUS_MASTER_ID <> 10006')
          .select(:id).distinct
          @order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001)
          .where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

          @order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000)
          .where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

          @order_masters_payu = OrderMaster.where(orderpaymentmode_id: 10080)
          .where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .where.not(ORDER_STATUS_MASTER_ID: @all_cancelled_orders).select(:id).distinct

         end



         if params.has_key?(:show)
           @show = params[:show]
           case @show # a_variable is the variable we want to compare
             when "all"    #compare to 1

               # order_masters = order_masters.select(:id).distinct
               # order_masters_cod = order_masters_cod.select(:id).distinct
               # order_masters_cc= order_masters_cc.select(:id).distinct
               # order_masters_payu = order_masters_payu.select(:id).distinct
               @btn1 = "btn btn-success"
               @orderdate = "Showing all "
             when "hbn"    #compare to 2
               @show = "hbn"
               @order_masters = @order_masters.joins(:medium).where("media.media_group_id = 10000")
               @order_masters_cod = @order_masters_cod.joins(:medium).where("media.media_group_id = 10000")
               @order_masters_cc= @order_masters_cc.joins(:medium).where("media.media_group_id = 10000")
               @order_masters_payu = @order_masters_payu.joins(:medium).where("media.media_group_id = 10000")
               @btn2 = "btn btn-success"
               @orderdate = "Showing all HBN"
             when "pvt"
               @show = "pvt"
               @order_masters = @order_masters.joins(:medium).where("media.media_group_id IS NULL")
               @order_masters_cod = @order_masters_cod.joins(:medium).where("media.media_group_id IS NULL")
               @order_masters_cc= @order_masters_cc.joins(:medium).where("media.media_group_id IS NULL")
               @order_masters_payu = @order_masters_payu.joins(:medium).where("media.media_group_id IS NULL")
               @btn3 = "btn btn-success"
               @orderdate = "Showing all Pvt"
             else
               @orderdate =  "Wrong Selection made"
           end
         end
        regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
        common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
        basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)

        reg_order_lines = OrderLine.where(orderid: @order_masters).where(productvariant_id: regular_product_variant_list).select(:product_list_id).distinct
        common_order_lines = OrderLine.where(orderid: @order_masters).where(productvariant_id: common_sell_product_variant_list).select(:product_list_id).distinct
        basic_order_lines = OrderLine.where(orderid: @order_masters).where(productvariant_id: basic_sell_product_variant_list).select(:product_list_id).distinct
        
        @total_main_nos, @total_common_nos, @total_basic_nos = 0, 0, 0
        #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
          main_product_list_orderlist ||= []
          num = 1
          reg_order_lines.each do |o|
          e = o.product_list_id

          name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
          orderlist = OrderLine.where(orderid: @order_masters).where(product_list_id: e)
          timetaken = orderlist.sum(:codcharges)
          payuvalue = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).sum(:total)
          payuorders = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).count()
          ccvalue = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          main_product_list_orderlist << {:total => totalorders,
             :id => e, :product => name, :for_date =>  @or_for_date,
                :prod => o.product_list.extproductcode,
            :nos => noorders, :payuvalue => payuvalue, :payuorders => payuorders,
            :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
           @total_main_nos += noorders if noorders.present?
          end
          @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse
          
           
          common_product_list_orderlist ||= []
          common_order_lines.each do |o|
          e = o.product_list_id

          name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
          orderlist = OrderLine.where(orderid: @order_masters).where(product_list_id: e)
          timetaken = orderlist.sum(:codcharges)
          payuvalue = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).sum(:total)
          payuorders = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).count()
          ccvalue = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          common_product_list_orderlist << {:total => totalorders,
             :id => e, :product => name, :for_date =>  @or_for_date,
                :prod => o.product_list.extproductcode,
            :nos => noorders, :payuvalue => payuvalue, :payuorders => payuorders,
            :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          
           @total_common_nos += noorders if noorders.present?
          end
          @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse
          

         basic_product_list_orderlist ||= []
          basic_order_lines.each do |o|
          e = o.product_list_id

          name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
          orderlist = OrderLine.where(orderid: @order_masters).where(product_list_id: e)
          timetaken = orderlist.sum(:codcharges)
          payuvalue = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).sum(:total)
          payuorders = OrderLine.where(orderid: @order_masters_payu).where(product_list_id: e).count()
          ccvalue = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: @order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: @order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          basic_product_list_orderlist << {:total => totalorders,
            :id => e, :product => name, :for_date =>  @or_for_date,
            :prod => o.product_list.extproductcode,
            :nos => noorders,:payuvalue => payuvalue, :payuorders => payuorders,
            :codorders => codorders, :codvalue => codvalue,
            :ccorders => ccorders, :ccvalue => ccvalue  }
            @total_basic_nos += noorders if noorders.present?
          end
          @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse
          
          
          @from_date = (@from_date).strftime("%Y-%m-%d")
          @to_date = (@to_date).strftime("%Y-%m-%d")

          respond_to do |format|
            csv_file_name = "products_sold_report_#{@or_for_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
              end
          end

       end
  end

  def all_cancelled_orders
    @cancelled_status_id = [10040, 10006, 10008]
    @cancelled_status_sql_list = '(10040, 10006, 10008)'
    #10040 => tranfer order cancelled
    #10006 => CFO and cancelled orders / unclaimed orders
    #10008 => Returned Order (post shipping)
    #session[:cancelled_status_id] = @cancelled_status_id
  end

  def drop_downs
    @medialist = Medium.where('media_group_id IS NULL or media_group_id <> 10000 or id = 11200').order('name')
    @hbnmedialist = Medium.where('media_group_id = 10000 AND id <> 11200').order('name')
    #employees with id in media
    media_bdm = Medium.all.select(:employee_id).distinct
    @all_bdm = Employee.all.where(id: media_bdm)

    @sales_staff = Employee.all.joins(:employee_role).where("employee_roles.sortorder > 7")
  end

  def use_from_to_date back_days=nil
    back_days = 1 if back_days == nil
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
 
end
