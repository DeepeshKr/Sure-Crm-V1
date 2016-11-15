class SalesReport 
attr_accessor :from_date, :to_date, :prod, :channel, :group, :media_id, :order_id, :total_nos, :total_value, :row_nos, :row_value, :host, :report_desc, :product_list_id, :product_variant_id

attr_accessor :name, :orderlist, :payuvalue, :payuorders, :ccvalue, :ccorders, :codorders, :codvalue, :totalorders,
:noorders

  def channel_group_sales_summary from_date, to_date, product_list_id
    cancelled_status_id = [10040, 10006, 10008]
    sales_report_list ||= []
  
    from_date = from_date.beginning_of_day - 330.minutes
    to_date = to_date.end_of_day - 330.minutes
     
    # show only hbn playlist .joins(:medium).where("media.media_group_id = 10000")
    order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
    .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', from_date, to_date)
    .joins(:order_line).where("order_lines.product_list_id = ?", product_list_id)
    .joins(:medium).where("media.media_group_id = 10000")
    .where.not(ORDER_STATUS_MASTER_ID: cancelled_status_id)
    .distinct.pluck(:media_id)
    
    amount = 0.0
    reverse_vat_rate = TaxRate.find(10001)
    
    order_masters.each do |ord|
      num, amount = 0, 0                 
      sales_report = SalesReport.new
      order_master_calculations = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
      .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', from_date, to_date)
      .joins(:order_line).where("order_lines.product_list_id = ?", product_list_id)
      .where.not(ORDER_STATUS_MASTER_ID: cancelled_status_id)
      .where(:media_id => ord)
      
        order_master_calculations.each do |orc|
          if orc.product_list_id == product_list_id
            if reverse_vat_rate.present?
              rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
              amount += orc.subtotal * rate_charge
            end
            num += 1
          end
        end
           
        media = Medium.find(ord)
        hbn = media.media_group.name || "Pvt" if media.media_group.present?
        
        sales_report.from_date = (from_date + 330.minutes).strftime("%Y-%m-%d")
        sales_report.to_date = (to_date + 330.minutes).strftime("%Y-%m-%d")
        sales_report.channel = media.media_state
        sales_report.group = hbn
        sales_report.media_id = ord
        sales_report.total_nos = num
        sales_report.total_value = amount.round(2)
       
        sales_report_list << sales_report
      end
    
    return sales_report_list
  end
  
  
  def showproducts from_date, to_date, show, start_time = nil, end_time = nil
    from_date =  Date.strptime(from_date, "%Y-%m-%d")
    to_date =  Date.strptime(to_date, "%Y-%m-%d")
    
    if from_date == nil
      return
    end
    
    if (start_time.present?) && (end_time.present?)
      from_date = Time.strptime(start_time, "%Y-%m-%d %H:%M")
      to_date = Time.strptime(end_time, "%Y-%m-%d %H:%M")
    else
      from_date = from_date.beginning_of_day - 330.minutes
      to_date = to_date.end_of_day - 330.minutes
    end

      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10000').where.not(ORDER_STATUS_MASTER_ID: all_cancelled_orders)
      .select(:id).distinct

      order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001)
      .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
      .where('ORDER_STATUS_MASTER_ID > 10000')
      .where.not(ORDER_STATUS_MASTER_ID: all_cancelled_orders).select(:id).distinct

      order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000)
      .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
      .where('ORDER_STATUS_MASTER_ID > 10000')
      .where.not(ORDER_STATUS_MASTER_ID: all_cancelled_orders).select(:id).distinct

      order_masters_payu = OrderMaster.where(orderpaymentmode_id: 10080)
      .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
      .where('ORDER_STATUS_MASTER_ID > 10000')
      .where.not(ORDER_STATUS_MASTER_ID: all_cancelled_orders).select(:id).distinct

     



     if show.present?
       case show # a_variable is the variable we want to compare
         when "hbn"    #compare to 2
           show = "hbn"
           order_masters = order_masters.joins(:medium).where("media.media_group_id = 10000")
           order_masters_cod = order_masters_cod.joins(:medium).where("media.media_group_id = 10000")
           order_masters_cc= order_masters_cc.joins(:medium).where("media.media_group_id = 10000")
           order_masters_payu = order_masters_payu.joins(:medium).where("media.media_group_id = 10000")
           btn2 = "btn btn-success"
           orderdate = "Showing all HBN"
         when "pvt"
           show = "pvt"
           order_masters = order_masters.joins(:medium).where("media.media_group_id IS NULL")
           order_masters_cod = order_masters_cod.joins(:medium).where("media.media_group_id IS NULL")
           order_masters_cc= order_masters_cc.joins(:medium).where("media.media_group_id IS NULL")
           order_masters_payu = order_masters_payu.joins(:medium).where("media.media_group_id IS NULL")
           btn3 = "btn btn-success"
           orderdate = "Showing all Pvt"
         else
           orderdate =  "Wrong Selection made"
       end
     else
       btn1 = "btn btn-success"
       orderdate = "Showing all "
     end

    @add_on_replacements = ProductMasterAddOn.where("activeid = 10000 AND replace_by_product_id IS NOT
    NULL").pluck(:product_list_id)
    @order_lines_regular = OrderLine.where(orderid: @order_id).joins(:product_variant)
    .where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_LIST_ID in (?)', 10000, @add_on_replacements)
      
    #regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
    reg_order_lines = OrderLine.where(orderid: order_masters)
    .joins(:product_variant)
    .joins(:product_list)
    .where("product_variants.product_sell_type_id = ? or product_lists.replace_main_product = ?", 10000, 1)
    .select(:product_list_id).distinct
    # .where("product_lists.replace_main_product = null or product_lists.replace_main_product = ?", 1)
    #.where("product_lists.replace_main_product is null or product_lists.replace_main_product = ?", 1)
    
    
    #common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
    common_order_lines = OrderLine.where(orderid: order_masters)
    .joins(:product_variant)
    .joins(:product_list)
    .where("product_variants.product_sell_type_id = ?", 10001)
    .where("product_lists.replace_main_product is null or product_lists.replace_main_product <> ?", 1)
    .select(:product_list_id).distinct
    # .where("product_lists.replace_main_product is null or product_lists.replace_main_product <> ?", 1)
    
    #basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)
    basic_order_lines = OrderLine.where(orderid: order_masters)
    .joins(:product_variant)
    .joins(:product_list)
    .where("product_variants.product_sell_type_id = ?", 10040)
    .where("product_lists.replace_main_product is null or product_lists.replace_main_product <> ?", 1)
    .select(:product_list_id).distinct
    # .where("product_lists.replace_main_product is null or product_lists.replace_main_product <> ?", 1)

    #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
    main_product_list_orderlist ||= []
    num = 1
    reg_order_lines.each do |o|
    e = o.product_list_id

    name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
    orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
    timetaken = orderlist.sum(:codcharges)
    payuvalue = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).sum(:subtotal)
    payuorders = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).count()
    ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:subtotal)
    ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
    codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
    codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:subtotal)
    totalorders = orderlist.sum(:subtotal)
    noorders = orderlist.count()
    main_product_list_orderlist << {:total => totalorders,
       :id => e, :product => name, :for_date =>  @or_for_date,
          :prod => o.product_list.extproductcode,
      :nos => noorders, :payuvalue => payuvalue, :payuorders => payuorders,
      :codorders => codorders, :codvalue => codvalue,
       :ccorders => ccorders, :ccvalue => ccvalue  }
    end
    
    @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse

    common_product_list_orderlist ||= []
    common_order_lines.each do |o|
    e = o.product_list_id

    name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
    orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
    timetaken = orderlist.sum(:codcharges)
    payuvalue = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).sum(:subtotal)
    payuorders = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).count()
    ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:subtotal)
    ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
    codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
    codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:subtotal)
    totalorders = orderlist.sum(:subtotal)
    noorders = orderlist.count()
    common_product_list_orderlist << {:total => totalorders,
       :id => e, :product => name, :for_date =>  @or_for_date,
          :prod => o.product_list.extproductcode,
      :nos => noorders, :payuvalue => payuvalue, :payuorders => payuorders,
      :codorders => codorders, :codvalue => codvalue,
       :ccorders => ccorders, :ccvalue => ccvalue  }
    end
    
    @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse

    basic_product_list_orderlist ||= []
    basic_order_lines.each do |o|
    e = o.product_list_id

      name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
      orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
      timetaken = orderlist.sum(:codcharges)
      payuvalue = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).sum(:subtotal)
      payuorders = OrderLine.where(orderid: order_masters_payu).where(product_list_id: e).count()
      ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:subtotal)
      ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
      codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
      codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:subtotal)
      totalorders = orderlist.sum(:subtotal)
      noorders = orderlist.count()
      basic_product_list_orderlist << {:total => totalorders, :id => e, :product => name, 
        :for_date =>  @or_for_date,:prod => o.product_list.extproductcode,
        :nos => noorders,:payuvalue => payuvalue, :payuorders => payuorders,
        :codorders => codorders, :codvalue => codvalue, :ccorders => ccorders, :ccvalue => ccvalue  }
    end
    @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse

    #this is for date on the view
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
    
    @filter = nil
    if params.has_key?(:filter)
      @filter = params[:filter]
      case @filter # a_variable is the variable we want to compare
        when "all"
        # @basic_product_list_orderlist
        # @common_product_list_orderlist
        # @main_product_list
        when "main"
           # @main_product_list = nil
           @basic_product_list_orderlist = nil
           @common_product_list_orderlist = nil
        when "basic"
          #@main_product_list = nil
          @basic_product_list_orderlist = nil
          #@common_product_list_orderlist = nil
        when "common"
          #@main_product_list = nil
          #@basic_product_list_orderlist = nil
          @common_product_list_orderlist = nil
        end
          
    end
    

  end
  
private

def all_cancelled_orders
  cancelled_status_id = [10040, 10006, 10008]
  cancelled_status_sql_list = '(10040, 10006, 10008)'
  #10040 => tranfer order cancelled
  #10006 => CFO and cancelled orders / unclaimed orders
  #10008 => Returned Order (post shipping)
  #session[:cancelled_status_id] = @cancelled_status_id
end

end