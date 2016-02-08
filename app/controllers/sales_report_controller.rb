class SalesReportController < ApplicationController
  before_action { protect_controllers(7) }
   respond_to :html
   before_action :drop_downs, only: [:city, :update, :destroy, :deleteupsell]
   before_action :all_cancelled_orders
  # before_filter :authenticate_user!
  def index
    @sales_agents = Employee.all.where(:employee_role_id => 10003).order("first_name")
    @product_master = ProductMaster.order('name') #.limit(10)
     @media_manager = Employee.where(:employee_role_id => 10121).order("first_name")
     @from_date = (Date.current + 330.minutes).strftime("%Y-%m-%d") #.strftime("%Y-%m-%d")
  end
  def summary
        @sno = 1
        @datelist ||= []
        employeeunorderlist ||= []

         #media segregation only HBN
          media_segments

          @from_date = Date.current - 7.days #30.days
          if params.has_key?(:from_date)
             @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
          end
          @to_date = Date.current
          if params.has_key?(:to_date)
             @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
          end

          @to_date.downto(@from_date).each do |day|
          @datelist <<  day.strftime('%d-%b-%y')
          web_date = day
          web_date = web_date.strftime()
          for_date = day # Date.
          @or_for_date = @from_date

          @from_date = for_date.beginning_of_day + 330.minutes
          @to_date = for_date.end_of_day + 330.minutes

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
           #.where(media_id: @hbnlist)
           @from_date = @from_date.strftime("%Y-%m-%d")
           @to_date = @to_date.strftime("%Y-%m-%d")

          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
          :for_date =>  web_date,
          :nos => noorders, :codorders => codorders, :codvalue => codvalue,
           :ccorders => ccorders, :ccvalue => ccvalue  }
        end
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:for_date]}
        # flash[:notice] = "remove restrictions of 10"

        respond_to do |format|
        csv_file_name = "sale_summary.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

  end

  def cdm_sales_summary
    @media_manager = Employee.where(:employee_role_id => 10121).order("first_name")
     @sno = 1

      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
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

     @bdm_id = params[:bdm_id]
     #  # Unclaimed order 10006
      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .joins(:medium).where("media.employee_id = ? ", @bdm_id).distinct.pluck(:media_id)
      #.select("date(orderdate) as ordered_date, sum(subtotal) as total_value")
      name = (Employee.find(@bdm_id))
      amount = 0.0
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []

      order_masters.each do |ord|
        @num = 0
        amount = 0
        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        # .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        # timetaken = orderlist.sum(:codcharges)
         reverse_vat_rate = TaxRate.find(10001)
         order_master_calculations = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
         .where('ORDER_STATUS_MASTER_ID > 10002')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .where(:media_id => ord)
         order_master_calculations.each do |orc|
           if reverse_vat_rate.present?
             rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
             amount += orc.subtotal * rate_charge

           end
           @num += 1
        end

        amount = amount.round(2)
        media_name = Medium.find(ord).name
          employeeunorderlist << {
            :from_date => (@from_date + 330.minutes).strftime("%Y-%m-%d"),
            :to_date => (@to_date + 330.minutes).strftime("%Y-%m-%d"),
            :channel => media_name,
            :media_id => ord,
            :total_nos => @num,
            :total_value => amount}

          end

      #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        respond_to do |format|
        csv_file_name = "#{name}_sales_#{@from_date}_#{@to_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

    end
  end

  def cdm_report
    @media_manager = Employee.where(:employee_role_id => 10121).order("first_name")
     @sno = 1

      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
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

     @bdm_id = params[:bdm_id]
     @media_id = params[:media_id] || nil if params.has_key?(:media_id)
     if @media_id.blank?
       return
     end
     if @media_id == nil && @from_date == nil && @to_date == nil
       return
     end

       @media_name = Medium.find(@media_id).name
         reverse_vat_rate = TaxRate.find(10001)

      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .where(media_id: @media_id)

      name = (Employee.find(@bdm_id))
      amount = 0.0
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      @num = 1
      amount = 0
      order_masters.each do |o|
        e = o.employee_id


        if reverse_vat_rate.present?
          rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
          amount = o.subtotal * rate_charge
          amount = amount.round(2)
        end

        products = ""
        #cats.each do |cat| cat.name end
        if o.order_line.present?
          #products = o.order_line.each(&:description)
          o.order_line.each do |ord| products << ord.description end
        end
        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        # .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        # timetaken = orderlist.sum(:codcharges)
        # totalorders = orderlist.sum(:total)
        # noorders = orderlist.count()

          employeeunorderlist << {:total => amount,
            :sno => @num,
            :orderdate =>  (o.orderdate + 330.minutes).strftime("%Y-%m-%d"),
            :city => o.city,
            :channel => o.medium.name,
            :products => products}
            @num += 1
          end

      #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        respond_to do |format|
        csv_file_name = "#{name}_#{@media_name}_sales_#{@from_date}_#{@to_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

    end
  end

  def channel_consolidated_daily_report

     @sno = 1
     if params.has_key?(:source)
       @source = params[:source]
     else
       @source = "All"
     end

      @from_date = Date.current
      @to_date = @from_date.end_of_day - 330.minutes
      if params[:from_date].present?
        @or_for_date = params[:from_date]
        for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")

        @from_date = for_date.beginning_of_day - 330.minutes
        @to_date = for_date.end_of_day - 330.minutes
      #@to_date = @from_date + 1.day
      end

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end

      @to_date = @to_date.end_of_day - 330.minutes

      #  # Unclaimed order 10006

      if @from_date == nil
        return
      end

        if @source == "hbn"
          order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where("media.media_group_id = 10000")
          .joins(:medium).distinct.pluck(:media_id)
        elsif @source == "pvt"
            order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .joins(:medium).where("media.media_group_id IS NULL")
          .distinct.pluck(:media_id)
          #.limit(2)
        else
          order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .joins(:medium).distinct.pluck(:media_id)

        end

      # .limit(10)
      #.select("date(orderdate) as ordered_date, sum(subtotal) as total_value")
    #  name = (Employee.find(@bdm_id))
      amount = 0.0
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      mainlist ||= []
      sublist ||= []

      order_masters.each do |ord|

        @num = 0
        amount = 0
        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        # .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        # timetaken = orderlist.sum(:codcharges)
         reverse_vat_rate = TaxRate.find(10001)
         order_master_calculations = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
         .where('ORDER_STATUS_MASTER_ID > 10002')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .where(:media_id => ord)

         order_master_calculations.each do |orc|
           if reverse_vat_rate.present?
             rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
             amount += orc.subtotal * rate_charge

           end
           @num += 1
         end

        amount = amount.round(2)
        media = Medium.find(ord)
        media_name = media.name
        hbn = media.media_group.name || nil if media.media_group.present?

        @order_cities = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: ord).group(:city).count



        @main_products = OrderLine.joins(:order_master).where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where("order_masters.media_id = ?", ord).joins(:product_variant)
        .where("product_variants.product_sell_type_id = ?", 10000)
        .joins(:product_list).group("product_lists.extproductcode")
        .sum(:pieces)

        @bas_upsell_products = OrderLine.joins(:order_master)
        .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where("order_masters.media_id = ?", ord).joins(:product_variant)
        .where("product_variants.product_sell_type_id = ?", 10040)
        .joins(:product_list)
        .group("product_lists.extproductcode").sum(:pieces)

        @com_upsell_products = OrderLine.joins(:order_master).where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where("order_masters.media_id = ?", ord).joins(:product_variant)
        .where("product_variants.product_sell_type_id = ?", 10001)
        .joins(:product_list).group("product_lists.extproductcode").sum(:pieces)

        @free_products = OrderLine.joins(:order_master)
        .where('order_masters.orderdate >= ? AND order_masters.orderdate <= ?', @from_date, @to_date)
        .where('order_masters.ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where("order_masters.media_id = ?", ord).joins(:product_variant)
        .where("product_variants.product_sell_type_id = ?", 10060)
        .joins(:product_list).group("product_lists.name").sum(:pieces)

        #.joins(:product_list).select('product_lists.name as name, count(*) as count, sum(order_lines.total) as total').group('product_list_id')


        #.group_by{|oc| oc.city}
        @order_cities = @order_cities.sort_by{|c| c[1]}.reverse
        @main_products = @main_products.sort_by{|c| c[1]}.reverse
        @bas_upsell_products = @bas_upsell_products.sort_by{|c| c[1]}.reverse
        @com_upsell_products = @com_upsell_products.sort_by{|c| c[1]}.reverse
        @first_order = @from_date
        @last_order = @to_date
          mainlist << {
            :from_date => (@from_date + 330.minutes).strftime("%Y-%m-%d"),
            :to_date => (@to_date + 330.minutes).strftime("%Y-%m-%d"),
            :channel => media_name,
            :group => hbn,
            :details => nil,
            :media_id => ord,
            :total_nos => @num,
            :total_value => amount,
            :city_list => @order_cities,
            :main_products => @main_products,
            :bas_upsell_products => @bas_upsell_products,
            :com_upsell_products => @com_upsell_products
            }

          end

      #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @mainlist = mainlist.sort_by{|c| c[:total_value]}.reverse


        respond_to do |format|
        csv_file_name = "#{ @source}_channel_consolidated_daily_report_#{@from_date}_#{@to_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

  end

  def channel_sales_summary
    # @media_manager = Medium.where(:media_commision_id => 10000).where("id <> 11200 and id <> 11700")
     @sno = 1
     if params.has_key?(:source)
       @source = params[:source]
     end
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
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

     @bdm_id = params[:bdm_id]
     #  # Unclaimed order 10006
      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .joins(:medium).distinct.pluck(:media_id)
      #.select("date(orderdate) as ordered_date, sum(subtotal) as total_value")
    #  name = (Employee.find(@bdm_id))
      amount = 0.0
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []

      order_masters.each do |ord|
        @num = 0
        amount = 0
        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        # .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        # timetaken = orderlist.sum(:codcharges)
         reverse_vat_rate = TaxRate.find(10001)
         order_master_calculations = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
         .where('ORDER_STATUS_MASTER_ID > 10002')
         .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
         .where(:media_id => ord)
         order_master_calculations.each do |orc|
           if reverse_vat_rate.present?
             rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
             amount += orc.subtotal * rate_charge

           end
           @num += 1
        end

        amount = amount.round(2)

        media = Medium.find(ord)
        media_name = media.name
        hbn = media.media_group.name || "Pvt" if media.media_group.present?

          employeeunorderlist << {
            :from_date => (@from_date + 330.minutes).strftime("%Y-%m-%d"),
            :to_date => (@to_date + 330.minutes).strftime("%Y-%m-%d"),
            :channel => media_name,
            :group => hbn,
            :media_id => ord,
            :total_nos => @num,
            :total_value => amount}

          end

      #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        respond_to do |format|
        csv_file_name = "channel_sales_#{@from_date}_#{@to_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

    end
  end

  def channel_summary_report
    #@media_manager = Employee.where(:employee_role_id => 10121).order("first_name")
     @sno = 1
     if params.has_key?(:source)
       @source = params[:source]
     end
      #@order_master.orderpaymentmode_id == 10000 #paid over CC
      #@order_master.orderpaymentmode_id == 10001 #paid over COD
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

     #@bdm_id = params[:bdm_id]
     @media_id = params[:media_id] || nil if params.has_key?(:media_id)
     if @media_id.blank?
       return
     end
     if @media_id == nil && @from_date == nil && @to_date == nil
       return
     end

       @media_name = Medium.find(@media_id).name
         reverse_vat_rate = TaxRate.find(10001)

      order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .where(media_id: @media_id)

    #  name = (Employee.find(@bdm_id))
      amount = 0.0
      #@orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
      employeeunorderlist ||= []
      @num = 1
      amount = 0
      order_masters.each do |o|
        e = o.employee_id


        if reverse_vat_rate.present?
          rate_charge = reverse_vat_rate.reverse_rate ||= 0.8888889
          amount = o.subtotal * rate_charge
          amount = amount.round(2)
        end

        products = ""
        #cats.each do |cat| cat.name end
        if o.order_line.present?
          #products = o.order_line.each(&:description)
          o.order_line.each do |ord| products << ord.description end
        end
        # orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        # .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
        # timetaken = orderlist.sum(:codcharges)
        # totalorders = orderlist.sum(:total)
        # noorders = orderlist.count()

          employeeunorderlist << {:total => amount,
            :sno => @num,
            :orderdate =>  (o.orderdate + 330.minutes).strftime("%Y-%m-%d"),
            :city => o.city,
            :channel => o.medium.name,
            :products => products}
            @num += 1
          end

      #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
        @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        respond_to do |format|
        csv_file_name = "#{@media_name}_sales_#{@from_date}_#{@to_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

    end
  end

  def disposition_report
    if params[:from_date].present?
    #     #@summary ||= []
        @orderdate =  "Please select a date to generate the report"
        for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = for_date.beginning_of_day - 330.minutes
        @to_date = for_date.end_of_day - 330.minutes

      if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      end
      #@to_date =
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d") || Date.current if params.has_key?(:to_date)

      @to_date = @to_date.end_of_day - 330.minutes
      @from_date = for_date.beginning_of_day - 330.minutes

      #@to_date = (@to_date + 330.minutes)
    #
      interaction_masters = InteractionMaster.where('createdon >= ? AND createdon <= ?', @from_date, @to_date)
      .joins(:interaction_category)
      .where("interaction_categories.sortorder < 100 and interaction_categories.sortorder <> 25 and interaction_categories.sortorder <> 26 and interaction_categories.sortorder <> 27")
      @orderdate = "Open Orders order between #{@from_date} and #{@to_date} found records!"

    # => Customer.find(inm.customer_id).fullname ||= "NA" if inm.customer?
    # Customer.find(inm.customer_id).fullname ||= "NA" if inm.customer_id.present?
    #   name = Employee.find(inm.employee_id).first_name ||= "NA" if Employee.find(inm.employee_id).present?
    # #Employee.find(e).first_name ||= "NA" #if Employee.find(e).first_name.present?)
      @sno = 1
        employeeunorderlist ||= []
        num = 1
      interaction_masters.each do |inm|

          customer_name = inm.customer_id
          name = inm.employee_id
          products = ""
          #cats.each do |cat| cat.name end
          if inm.orderid.present?

          order_masters = OrderMaster.find(inm.orderid)
          city = order_masters.city ||= "NA"
          total = order_masters.g_total
              channel = Medium.find(order_masters.media_id).name ||= "NA" if order_masters.media_id.present?
              products << "Ref No: #{inm.orderid} Products: "
            if order_masters.order_line.present?
              inm.order_master.order_line.each do |ord| products << ord.description end
            end
          end
          employeeunorderlist << {:total => total,
          :sno => num,
          :employee => name,
          :mobile => inm.mobile,
          :customer => customer_name,
          :on_date =>  (inm.createdon + 330.minutes).strftime("%Y-%m-%d %H:%M"),
          :products => products,
          :city => city,
          :channel => channel,
          :disposition => inm.interaction_category.name,
          :no_of =>  num}
           num += 1
        end
        # CSV.generate_line([c[:sno], c[:mobile], c[:employee], c[:order_date], c[:customer], c[:phone], c[:product], c[:total], c[:address], c[:city], c[:total]]).html_safe.strip


        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

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
    #
    end #end if

  end

  def open_orders
    #     #media segregation only HBN
    #     #media_segments
    #     @sno = 1
    #
    if params[:from_date].present?
    #     #@summary ||= []
        @orderdate =  "Please select a date to generate the report"
        for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = for_date.beginning_of_day - 330.minutes
        @to_date = for_date.end_of_day - 330.minutes
      if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      end
      #@to_date =
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d") || Date.current if params.has_key?(:to_date)

      @to_date = @to_date.end_of_day - 330.minutes

      @from_date = (@from_date + 330.minutes)
      @to_date = (@to_date + 330.minutes)
    #
    order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID < 10003')
    .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date) #.limit(20)
    #
      @orderdate = "Open Orders order between #{@from_date} and #{@to_date} found #{order_masters.count} orders!"

    # =>
    @sno = 1
        employeeunorderlist ||= []
        num = 1
        order_masters.each do |o|
          e = o.employee_id
          name = Employee.find(e).first_name ||= "NA" #if Employee.find(e).first_name.present?)
          channel = Medium.find(o.media_id).name ||= "NA" if o.media_id.present?
          customer_name = Customer.find(o.customer_id).fullname ||= "NA" if o.customer_id.present?
          products = ""
          #cats.each do |cat| cat.name end
          if o.order_line.present?
            #products = o.order_line.each(&:description)
            o.order_line.each do |ord| products << ord.description end
          end


          employeeunorderlist << {:total => o.total,
            :sno => num,
          :employee => name,
          :mobile => o.mobile,
          :customer => customer_name,
          :orderdate =>  o.orderdate.strftime("%Y-%m-%d"),
          :products => products,
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
          csv_file_name = "open_orders_on_#{@from_date}_to_#{@to_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
        end #end csv
    #
    end #end if
    #
  end #end function

  def pincode_orders
    #     #media segregation only HBN
    #     #media_segments
    #     @sno = 1
    #
    order_master = OrderMaster.limit(0)
    return order_master if params[:from_date].blank?
    return order_master if params[:pincode].blank?
    if params[:from_date].present?
    #     #@summary ||= []
        @orderdate =  "Please select a date to generate the report"
        for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = for_date.beginning_of_day - 330.minutes
        @to_date = for_date.end_of_day - 330.minutes
      if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      end
      #@to_date =
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d") || Date.current if params.has_key?(:to_date)

      @to_date = @to_date.end_of_day - 330.minutes

      @from_date = (@from_date + 330.minutes)
      @to_date = (@to_date + 330.minutes)
    #
    @pincode = ""
    if params[:pincode].present?
      @pincode = params[:pincode]
      order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
      .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
      .where("pincode = ?", @pincode).limit(20)
    else
        order_masters = OrderMaster.limit(0)
    end
      @orderdate = "Pincode orders for #{@pincode} between #{@from_date} and #{@to_date} found #{order_masters.count} orders!"
    #
    # =>
    @sno = 1
        employeeunorderlist ||= []
        num = 1
        order_masters.each do |o|
          e = o.employee_id
          name = Employee.find(e).first_name ||= "NA" #if Employee.find(e).first_name.present?)
          channel = Medium.find(o.media_id).name ||= "NA" if o.media_id.present?
          customer_name = Customer.find(o.customer_id).fullname ||= "NA" if o.customer_id.present?
          products = ""
          #cats.each do |cat| cat.name end
          if o.order_line.present?
            #products = o.order_line.each(&:description)
            o.order_line.each do |ord| products << ord.description end
          end


          employeeunorderlist << {:total => o.total,
            :sno => num,
          :employee => name,
          :mobile => o.mobile,
          :customer => customer_name,
          :orderdate =>  o.orderdate.strftime("%Y-%m-%d"),
          :products => products,
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
       if @employeeorderlist.present?
         respond_to do |format|
           csv_file_name = "orders_from_pincode#{@pincode}_#{@from_date}_to_#{@to_date}.csv"
             format.html
             format.csv do
               headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
               headers['Content-Type'] ||= 'text/csv'
             end
         end #end csv
       end

    #
    end #end if
    #
  end #end function

  def daily
        #media segregation only HBN
        media_segments
        @sno = 1

      if params[:from_date].present?
        #@summary ||= []
       @from_date = Date.current - 7.days #30.days
            if params.has_key?(:from_date)
               @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
            end
      @to_date = Date.current
      if params.has_key?(:to_date)
       @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end

      @to_date.downto(@from_date).each do |day|

        order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
         .joins(:medium).where("media.media_group_id = 10000").select(:employee_id).distinct

        @orderdate = "Searched for #{@from_date} found #{order_masters.count} agents!"
        employeeunorderlist ||= []
        num = 1
        order_masters.each do |o|
          e = o.employee_id

          name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('ORDER_STATUS_MASTER_ID <> 10006').where('TRUNC(orderdate) = ?',for_date)
          .where(media_id: @hbnlist).where(employee_id: e)
          timetaken = orderlist.sum(:codcharges)
          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          employeeunorderlist << {:total => totalorders,
             :id => e, :employee => name, :for_date =>  @from_date,
            :nos => noorders, :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end
          @employeeorderlist = employeeunorderlist.sort_by{|c| c[:total]}.reverse

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

          respond_to do |format|
          csv_file_name = "sales_on_#{@from_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end #end csv
      end #end do
      end #end if

  end #end function

  def hourly
      #/sales_report/hourly?for_date=05%2F09%2F2015
      @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
      @sno = 1
      if params[:from_date].present?
        #@summary ||= []
        @or_for_date = Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")


        #for_date = for_date - 330.minutes
          @hourlist ||= []
          employeeunorderlist ||= []

          @from_date = @from_date.beginning_of_day - 300.minutes
          @to_date = @from_date + 1.days
          @to_date = @to_date.end_of_day - 300.minutes
          #media segregation only HBN
          media_segments

          #start loop

          (@from_date.to_datetime.to_i .. @to_date.to_datetime.to_i).step(30.minutes) do |date|

           halfhourago = Time.at(date - 30.minutes)


            orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
            .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
            .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
            #.joins(:medium).where("media.media_group_id = 10000")

            # orderlists = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006')
            # .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))


            #halfhourlist ||= []
              #  orderlists.each do |order_list|
              #     campaign_name = order_list.campaign_playlist.playlist_details + " " + order_list.campaign_playlist.starttime if order_list.campaign_playlist
               #
              #     products = ""
              #     #cats.each do |cat| cat.name end
              #     if order_list.order_line.present?
              #       #products = o.order_line.each(&:description)
              #       order_list.order_line.each do |ord| products << ord.description end
              #     end
              #     order_time = (order_list.orderdate + 300.minutes).strftime("%H:%M")
              #       halfhourlist << {
              #         :campaign => campaign_name,
              #         :products => products,
              #         :order_time => order_time,
              #         :order_id => order_list.external_order_no
              #          }
              #  end

            ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
            ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
            codorders = orderlist.where(orderpaymentmode_id: 10001).count()
            codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            employeeunorderlist << {:total => totalorders,
            :starttime =>  halfhourago.strftime("%d-%b %H:%M %p"),
            :endtime => Time.at(date).strftime("%d-%b %H:%M %p"),
            :start_time => (halfhourago - 330.minutes).strftime("%Y-%m-%d %H:%M"),
            :end_time => (Time.at(date) - 330.minutes).strftime("%Y-%m-%d %H:%M"),
            :nos => noorders, :codorders => codorders,
            :codvalue => codvalue,
            :ccorders => ccorders, :ccvalue => ccvalue  }
          end
         @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

         respond_to do |format|
          csv_file_name = "sales_hourly_#{@from_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end

       end

  end
  def hour_sales
    #/sales_report/hourly?for_date=05%2F09%2F2015
  #  @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    if params[:from_date].present?
      #@summary ||= []
      @or_for_date = Date.strptime(params[:from_date], "%Y-%m-%d")
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")


      #for_date = for_date - 330.minutes
        @hourlist ||= []
        employeeunorderlist ||= []

        @from_date = @from_date.beginning_of_day - 300.minutes
        @to_date = @from_date + 1.days
        @to_date = @to_date.end_of_day - 300.minutes
        #media segregation only HBN
        media_segments

        #start loop

        (@from_date.to_datetime.to_i .. @to_date.to_datetime.to_i).step(30.minutes) do |date|

         halfhourago = Time.at(date - 30.minutes)


          orderlists = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))
          #.joins(:medium).where("media.media_group_id = 10000")

          # orderlists = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006')
          # .where('orderdate >= ? AND orderdate <= ?', halfhourago, Time.at(date))


          halfhourlist ||= []
             orderlists.each do |order_list|
                campaign_name = order_list.campaign_playlist.playlist_details + " " + order_list.campaign_playlist.starttime if order_list.campaign_playlist

                products = ""
                #cats.each do |cat| cat.name end
                if order_list.order_line.present?
                  #products = o.order_line.each(&:description)
                  order_list.order_line.each do |ord| products << ord.description end
                end
                hbn = order_list.medium.media_group.name || nil if order_list.medium.media_group.present?

                order_time = (order_list.orderdate + 330.minutes).strftime("%H:%M")
                  halfhourlist << {
                    :campaign => campaign_name,
                    :products => products,
                    :channel => order_list.medium.name,
                    :hbn => hbn,
                    :agent => order_list.employee.fullname,
                    :order_time => order_time,
                    :order_id => order_list.id,
                    :city => order_list.city,
                    :state => order_list.customer_address.state,
                    :order_no => order_list.external_order_no
                     }
             end

             total_order_nos = orderlists.count(:id)
             total_order_value = orderlists.sum(:g_total).round(0)
             s_no_i = 1

          # ccvalue = orderlists.where(orderpaymentmode_id: 10000).sum(:total)
          # ccorders = orderlists.where(orderpaymentmode_id: 10000).count()
          # codorders = orderlists.where(orderpaymentmode_id: 10001).count()
          # codvalue = orderlists.where(orderpaymentmode_id: 10001).sum(:total)
          # totalorders = orderlists.sum(:total)
          # noorders = orderlists.count()

          employeeunorderlist << {
          :order_date =>  @or_for_date,
          :time_start => (halfhourago).strftime("%H:%M"),
          :time_end => (Time.at(date)).strftime("%H:%M"),
          :total_nos => total_order_nos,
          :total_value => total_order_value,
          :blank => nil,
          :hourlist => halfhourlist}
        end
       @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse

      #this is for date on the view
      @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
      @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

       respond_to do |format|
        csv_file_name = "hour_sales_#{@from_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

     end

  end

  def hourly_products
     #@from_date = (330.minutes).from_now.to_date
    if params.has_key?(:from_date)
       @from_date = DateTime.strptime(params[:from_date], "%Y-%m-%d %H:%M")

    end
    #@to_date = (330.minutes).from_now.to_date
    if params.has_key?(:to_date)
       @to_date =  DateTime.strptime(params[:to_date], "%Y-%m-%d %H:%M")
    end
    @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
    .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
    .joins(:medium).where("media.media_group_id = 10000")
    .where("orderdate >= ? AND orderdate <= ?",@from_date, @to_date)
    .order("order_masters.created_at")

    ordernos = @order_masters.pluck(:id)
    main_product_type_id = 10000
    basic_product_type_id = 10040
    common_product_type_id = 10001
    @regular_basic,   @regular_shipping,  @regular_total,   @regular_cost,  @regular_revenue = 0,0,0,0,0
    @order_lines_regular = OrderLine.where(orderid: ordernos).joins(:product_variant).where("product_variants.product_sell_type_id = ?", main_product_type_id).order("order_lines.created_at")


        @order_lines_regular.each do |order |
          @regular_basic += order.subtotal
          @regular_shipping += order.shipping
          @regular_total += order.total
          @regular_cost += order.productcost
          @regular_revenue += order.productrevenue

        end

    @basic_basic,   @basic_shipping,  @basic_total,   @basic_cost,  @basic_revenue = 0,0,0,0,0
    @order_lines_basic = OrderLine.where(orderid: ordernos).joins(:product_variant).where("product_variants.product_sell_type_id = ?", basic_product_type_id).order("order_lines.created_at")

       @order_lines_basic.each do |order |
          @basic_basic += order.subtotal
          @basic_shipping += order.shipping
          @basic_total += order.total
          @basic_cost += order.productcost
          @basic_revenue += order.productrevenue

        end

    @common_basic,   @common_shipping,  @common_total,   @common_cost,  @common_revenue = 0,0,0,0,0
    @order_lines_common = OrderLine.where(orderid: ordernos).joins(:product_variant).where("product_variants.product_sell_type_id = ?", common_product_type_id).order("order_lines.created_at")

          @order_lines_common.each do |order |
          @common_basic += order.subtotal
          @common_shipping += order.shipping
          @common_total += order.total
          @common_cost += order.productcost
          @common_revenue += order.productrevenue

        end


     respond_to do |format|
         format.html
     end
  end

  def channel
        #/sales_report/channel?for_date=05%2F09%2F2015
        @sno = 1
        #@order_master.orderpaymentmode_id == 10000 #paid over CC
        #@order_master.orderpaymentmode_id == 10001 #paid over COD
      if params[:from_date].present?
        #@summary ||= []
        @or_for_date = params[:from_date]
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        #media segregation
        media_segments

        @from_date = @from_date.beginning_of_day - 330.minutes
        @to_date = @from_date.end_of_day - 330.minutes

        if params.has_key?(:to_date)
          @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
        end

        @to_date = @to_date.end_of_day - 330.minutes

        hbn_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @hbnlist1).select(:media_id, :city).distinct

        paid_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @paid).select(:media_id, :city).distinct

        other_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @others)
        .select(:media_id, :city).distinct

        total_hbn_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @hbnlist1)

        total_paid_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @paid)

        total_other_order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where(media_id: @others)

        @orderdate = "Orders for #{@from_date}: HBN Channel #{total_hbn_order_masters.count} for Rs. #{total_hbn_order_masters.sum(:total)}, Paid channels #{total_paid_order_masters.count} for Rs. #{total_paid_order_masters.sum(:total)} and Free Channel #{total_other_order_masters.count} for Rs. #{total_other_order_masters.sum(:total)}!"

        hbn_order_list ||= []
        num = 1
          #hbn channels
          hbn_order_masters.each do |o|
          e = o.media_id
          c = o.city
          name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where(media_id: e, city: c)
          timetaken = orderlist.sum(:codcharges)
          ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
          ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
          codorders = orderlist.where(orderpaymentmode_id: 10001).count()
          codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count(:id)

          hbn_order_list << {:total => totalorders,
             :id => e, :channel => name, :for_date =>  @or_for_date,
            :nos => noorders, :codorders => codorders, :codvalue => codvalue,
            :city => o.city,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end

          @hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse

          paid_order_list ||= []

          paid_order_masters.each do |o|
          e = o.media_id
          c = o.city
          name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where(media_id: e, city: c)
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
            :city => o.city,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end

          @paid_order_list = paid_order_list.sort_by{|c| c[:total]}.reverse

          other_order_list ||= []

          other_order_masters.each do |o|
          e = o.media_id
          c = o.city
          name = (Medium.find(e).name  || "NA" if Medium.find(e).name.present?)
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
          .where(media_id: e, city: c)
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
            :city => o.city,
             :ccorders => ccorders, :ccvalue => ccvalue}
          end

          @other_order_list = other_order_list.sort_by{|c| c[:total]}.reverse

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

          respond_to do |format|
          csv_file_name = "channel_sales_#{@or_for_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end


      end

  end

  def employee
        @sno = 1

        #@months = [['-', '']](1..12).each {|m| @months << [Date::MONTHNAMES[m], m]}
        #@order_master.orderpaymentmode_id == 10000 #paid over CC
        #@order_master.orderpaymentmode_id == 10001 #paid over COD
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


        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .select(:employee_id).distinct

        @orderdate = "Searched for #{for_date} found #{order_masters.count} agents!"
        employeeunorderlist ||= []
        num = 1
        order_masters.each do |o|
          e = o.employee_id

          name = (Employee.find(e).first_name  || "NA" if Employee.find(e).first_name.present?)
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date).where(employee_id: e)
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
  end
    # Processing by SalesReportController#city as HTML
    #   Parameters: {"utf8"=>"✓", "from_date"=>"2015-11-01", "to_date"=>"2015-11-30", "media_id"=>"10005", "commit"=>"Show Report"}

  def city
        @sno = 1
        @city_search_results = ""
        #@order_master.orderpaymentmode_id == 10000 #paid over CC
        #@order_master.orderpaymentmode_id == 10001 #paid over COD
      if params[:from_date].present?
        #@summary ||= []
        employeeunorderlist ||= []
        @or_for_date = params[:from_date]
        for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
         @from_date = for_date
        from_date = for_date.beginning_of_day - 330.minutes
        to_date = for_date.end_of_day - 330.minutes
        @to_date = for_date.end_of_day - 330.minutes
        #@to_date = @from_date + 1.day

        if params.has_key?(:to_date)
          @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
        end

        @to_date = @to_date.end_of_day - 330.minutes

        @city_search_results = "City search between dates #{@from_date} and #{@to_date}"
        total_count = 0

        if params.has_key?(:media_id)
          if params[:media_id].present?
             @media_id = params[:media_id]
              from_channel = Medium.find(params[:media_id]).name
            #    order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            #    .where(media_id: params[:media_id])
            # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL').uniq.pluck(:city)

            order_cities = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            .where('ORDER_STATUS_MASTER_ID > 10002')
            .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
            .where('city IS NOT NULL')
            .where(media_id: params[:media_id])
            .uniq.pluck(:city)



            # order_id_1 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL')
            # .where(media_id: params[:media_id])
            # .limit(1000).uniq.pluck(:id)
            #  order_id_2 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL')
            # .where(media_id: params[:media_id])
            # .offset(1000).limit(1000).uniq.pluck(:id)
            #  order_id_3 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL').where(media_id: params[:media_id])
            # .offset(2000).limit(1000).uniq.pluck(:id)


             if order_cities.present?
                total_count = order_cities.count
                @city_search_results = "City search between dates #{@from_date} and #{@to_date} for channel #{from_channel} got about #{order_cities.count} results"

              else
                @city_search_results = "City search between dates #{@from_date} and #{@to_date} for channel #{from_channel} got 0 results"
             end
           end
        else
        #    order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL')

        order_cities = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        .where('ORDER_STATUS_MASTER_ID > 10002')
        .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
        .where('city IS NOT NULL').uniq.pluck(:city)
        # order_id_1 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL').limit(1000).uniq.pluck(:id)
        #  order_id_2 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL').offset(1000).limit(1000).uniq.pluck(:id)
        #  order_id_3 = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
        # .where('ORDER_STATUS_MASTER_ID > 10002').where('city IS NOT NULL').offset(2000).limit(1000).uniq.pluck(:id)



        @orderdate = "Searched for #{for_date} #{from_channel} found #{total_count} cities!"

        num = 1
        if order_cities.present?

          @city_search_results = "City search between dates #{@from_date} and #{@to_date} for all channels got about #{order_cities.count} results"
           end

        order_cities.each do |o|
          city = o #.city
          if city.present?
                #city = CustomerAddress.find(e).city  #  || "NA" if Employee.find(e).first_name.present?)

               orderlist = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
              .where('ORDER_STATUS_MASTER_ID > 10002')
              .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
              .where('city IS NOT NULL').where("city = ?", city)

             if params.has_key?(:media_id)
              orderlist = orderlist.where(media_id: params[:media_id])
             end
            timetaken = orderlist.sum(:codcharges)
            ccvalue = orderlist.where(orderpaymentmode_id: 10000).sum(:total)
            ccorders = orderlist.where(orderpaymentmode_id: 10000).count()
            codorders = orderlist.where(orderpaymentmode_id: 10001).count()
            codvalue = orderlist.where(orderpaymentmode_id: 10001).sum(:total)
            totalorders = orderlist.sum(:total)
            noorders = orderlist.count()
            employeeunorderlist << {:total => totalorders,
                :employee => city, :for_date =>  @or_for_date,
              :nos => noorders, :codorders => codorders, :codvalue => codvalue,
               :ccorders => ccorders, :ccvalue => ccvalue  }

          else
              @city_search_results = "City search between dates #{@from_date} and #{@to_date} for all channels 0 results"

        end

        end
      end
          @employeeorderlist = employeeunorderlist.sort_by{|c| [c[:employee], c[:total]]}.reverse

        #this is for date on the view
        @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
        @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

          respond_to do |format|
          csv_file_name = "city_sales_#{@or_for_date}.csv"
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end

      end
  end

  def product_sold
      @ordersearch = "No Products sold for the period / day"
       @product_master = ProductMaster.where(productactivecodeid: 10000).order('name') #.limit(10)
    if params[:from_date].present?
        #@summary ||= []
        @or_for_date = params[:from_date]
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        #@from_date = for_date.beginning_of_day - 330.minutes
        product_name = " "
        #from_date = @from_date.beginning_of_day - 330.minutes
        @to_date = @from_date.end_of_day - 330.minutes
        if params.has_key?(:to_date)
           @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
           @to_date = @to_date.end_of_day - 330.minutes

        end
        sold_product_list ||= []

        if params.has_key?(:product_master_id)
          @product_master_id = params[:product_master_id]
          sold_product_list = OrderLine.where('order_lines.orderdate >= ? and order_lines.orderdate <= ?', @from_date, @to_date)
          .where(product_master_id: @product_master_id).joins(:order_master)
          .where('ORDER_MASTERS.ORDER_STATUS_MASTER_ID > 10002')
          .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)#.limit(10)
          #.uniq.pluck(:orderid)
          product_name = ProductMaster.find(@product_master_id).name

           @order_lines_csv ||= []
                sold_product_list.each do |o|
                  @order_lines_csv << {:order_no => o.order_master.external_order_no,
                :ref_no => o.orderid, :order_date =>  (o.order_master.orderdate + 330.minutes).strftime('%d-%b-%Y'),
                :customer => o.order_master.customer.first_name + " " + o.order_master.customer.last_name,
                :phone => o.order_master.mobile + " / " + o.order_master.customer_address.telephone1,
                :address => o.order_master.customer_address.address1.gsub(/,/, '').strip + " " + o.order_master.customer_address.address2.gsub(/,/, '').strip + " " + o.order_master.customer_address.address3.gsub(/,/, '').strip + " " +  o.order_master.customer_address.landmark.gsub(/,/, '').strip,
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

  def product
       @sno = 1
       showproducts
  end

  def show
      #add this link to show
      #<%= link_to "View PPO", ppo_details_path(campaign_id: c[:campaign_id]), :target => "_blank" %>
      @searchaction = "show"
      for_date = (330.minutes).from_now.to_date

      if params.has_key?(:from_date)
       for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      end
       @sno = 1

      @total_nos = 0
      @total_pieces = 0
      @total_sales = 0

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

       campaign_playlists.each do | playlist |
       orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
       .where(campaign_playlist_id: playlist.id)

        totalorders = orderlist.sum(:total)
             nos = orderlist.count()
           pieces = orderlist.sum(:pieces)
            employeeunorderlist << {:show =>  playlist.product_variant.name,
            :campaign_id => playlist.id,
             :pieces => pieces,
            :nos => nos,
            :at_time => playlist.starttime,
            :total => totalorders}
          end
          @employeeorderlist = employeeunorderlist


  end

  def order_summary
      #aggregation based on products
     @sno = 1
      showproducts
      shows_between

  end #end of def

  def sales_incentives
    @show_results = "false"
    @sales_agents = Employee.all.where(:employee_role_id => 10003).order("first_name")
          @employee_id = params[:employee_id]
          if @employee_id.blank?
            return
          end
          @employee_name = Employee.find(@employee_id).fullname
          @this_month = Date.today.strftime("%Y-%m")
          @last_month = (Date.today - 1.month).strftime("%Y-%m")
          @earlier_month = (Date.today - 2.month).strftime("%Y-%m")

          employee_sale = EmployeeSales.new
          @employee_sales_1 = employee_sale.sales_data @this_month, @employee_id
          @employee_sales_2 = employee_sale.sales_data @last_month, @employee_id
          @employee_sales_3 = employee_sale.sales_data @earlier_month, @employee

            @show_results = "true"
  end

  def orderlisting
      @t = (330.minutes).from_now
      @sno = 1
      for_date = (330.minutes).from_now.to_date

      if params.has_key?(:for_date)
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      end

      from_date = for_date.beginning_of_day - 330.minutes
      to_date = for_date.end_of_day - 330.minutes


      @orderlistabout = "for date #{for_date}"
      @order_masters =  OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
      .where('ORDER_STATUS_MASTER_ID > 10002')
      .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)

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
              @order_masters = @order_masters.where('campaign_playlist_id IS NULL')
              .order("orderdate")
              @orderlistabout = "for selected playlist HBN Missed orders"
            end
        end
      end
      if params.has_key?(:employee_id).present?
        @employee_id = params[:employee_id]
        employee = Employee.find(@employee_id).fullname
        if params[:completed].present?
          # all completed orders only
           if params[:for_date].present?
            for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")

            @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
            .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
            .where('orderdate >= ? AND orderdate <= ?', from_date, to_date)
            .where(employee_id: @employee_id).order("id")
            @orderdesc = "#{@order_masters.count()} orders of #{employee} for #{for_date}"

           end
        else
           @orderdesc = "Recent 1000 all orders of #{employee} "
            @order_masters = OrderMaster.where(employee_id: @employee_id)
            .order("id DESC").limit(1000)
        end

      end

      if params.has_key?(:start_time) && params.has_key?(:end_time)
        start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M")
        end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M")


       @order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
       .where.not(ORDER_STATUS_MASTER_ID: @cancelled_status_id)
       .where('orderdate >= ? AND orderdate <= ?', start_time, end_time)
       @orderlistabout = "for selected playlist #{for_date} between #{start_time} and #{end_time} "
      end



  end #end of def

  def fitness_products_sold
      @ordersearch = "No Products sold for the period / day"
      @fitness_prods = ["1AK", "1AZF", "ABT", "MBL", "SCP", "TGR2", "2FP", "PMP", "MXC", "TOTS", "TOTD", "3BCR", "PBS", "BTN", "WCS1", "BFA5", "3AC", "1IZN", "HTS", "1HTB", "2HTB", "2SU"]

    if params[:from_date].present?
        #@summary ||= []
        @or_for_date = params[:from_date]
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @from_date = @from_date.beginning_of_day - 330.minutes
        #from_date = @from_date.beginning_of_day - 330.minutes
        @to_date = @from_date.end_of_day - 330.minutes
        if params.has_key?(:to_date)
           @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
           @to_date = @to_date.end_of_day - 330.minutes

        end

        product_list_id = ProductList.where(extproductcode: @fitness_prods).pluck(:id)
        #order_list =

        sold_product_list ||= []

        sold_product_list = OrderLine.where('order_lines.orderdate >= ? and order_lines.orderdate <= ?', @from_date, @to_date)
        .where(product_list_id: product_list_id).joins(:order_master)
        .where('ORDER_MASTERS.ORDER_STATUS_MASTER_ID > 10002')
        .where.not('ORDER_MASTERS.ORDER_STATUS_MASTER_ID IN (10040, 10006, 10008)')
        #@cancelled_status_id
        #.limit(10)
          #.uniq.pluck(:orderid)

          @order_lines_csv ||= []
               sold_product_list.each do |o|
                 email_id = o.order_master.customer.emailid || nil if o.order_master.customer.emailid.present?

                 @order_lines_csv << {:order_no => o.order_master.external_order_no,
               :ref_no => o.orderid, :order_date =>  (o.order_master.orderdate + 330.minutes).strftime('%d-%b-%Y'),
               :customer => o.order_master.customer.first_name + " " + o.order_master.customer.last_name,
               :phone => o.order_master.mobile + " / " + o.order_master.customer_address.telephone1,
               :email_id => o.order_master.customer.emailid,
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
            csv_file_name = "fitness_products_sold_#{@from_date}_#{@to_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
              end
          end

        end

  end


  private

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

  def showproducts
     #@summary ||= []
     if params[:from_date].present?
        #@summary ||= []
        @or_for_date = params[:from_date]
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
        media_segments

        order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006').select(:id).where(media_id: @hbnlist).distinct
        order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('orderdate >= ? AND orderdate <= ?', from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct
        order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('orderdate >= ? AND orderdate <= ?', from_date, to_date).where('ORDER_STATUS_MASTER_ID > 10002').where(media_id: @hbnlist).select(:id).distinct

         if params.has_key?(:start_time) && params.has_key?(:end_time)
          start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M")
          end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M")

          @Show_start_time = start_time.strftime("%H:%M")
          @Show_end_time = end_time.strftime("%H:%M")


          order_masters = OrderMaster.where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006').where(media_id: @hbnlist).select(:id).distinct
          order_masters_cod = OrderMaster.where(orderpaymentmode_id: 10001).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006').where(media_id: @hbnlist).select(:id).distinct
          order_masters_cc = OrderMaster.where(orderpaymentmode_id: 10000).where('orderdate >= ? AND orderdate <= ?', start_time, end_time).where('ORDER_STATUS_MASTER_ID > 10002').where('ORDER_STATUS_MASTER_ID <> 10006').where(media_id: @hbnlist).select(:id).distinct
         end

        regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)
        common_sell_product_variant_list = ProductVariant.where(product_sell_type_id: 10001)
        basic_sell_product_variant_list =  ProductVariant.where(product_sell_type_id: 10040)

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
          ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          main_product_list_orderlist << {:total => totalorders,
             :id => e, :product => name, :for_date =>  @or_for_date,
                :prod => o.product_list.extproductcode,
            :nos => noorders, :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end
          @main_product_list = main_product_list_orderlist.sort_by{|c| c[:total]}.reverse

          common_product_list_orderlist ||= []
          common_order_lines.each do |o|
          e = o.product_list_id

          name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
          orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
          timetaken = orderlist.sum(:codcharges)
          ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          common_product_list_orderlist << {:total => totalorders,
             :id => e, :product => name, :for_date =>  @or_for_date,
                :prod => o.product_list.extproductcode,
            :nos => noorders, :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end
          @common_product_list_orderlist = common_product_list_orderlist.sort_by{|c| c[:total]}.reverse


         basic_product_list_orderlist ||= []
          basic_order_lines.each do |o|
          e = o.product_list_id

          name = (ProductList.find(e).productlistdetails  || "NA" if ProductList.find(e).productlistdetails.present?)
          orderlist = OrderLine.where(orderid: order_masters).where(product_list_id: e)
          timetaken = orderlist.sum(:codcharges)
          ccvalue = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).sum(:total)
          ccorders = OrderLine.where(orderid: order_masters_cc).where(product_list_id: e).count()
          codorders = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).count()
          codvalue = OrderLine.where(orderid: order_masters_cod).where(product_list_id: e).sum(:total)
          totalorders = orderlist.sum(:total)
          noorders = orderlist.count()
          basic_product_list_orderlist << {:total => totalorders,
             :id => e, :product => name, :for_date =>  @or_for_date,
             :prod => o.product_list.extproductcode,
            :nos => noorders, :codorders => codorders, :codvalue => codvalue,
             :ccorders => ccorders, :ccvalue => ccvalue  }
          end
          @basic_product_list_orderlist = basic_product_list_orderlist.sort_by{|c| c[:total]}.reverse

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

  def media_segments
    @hbnlist = Medium.where(media_group_id: 10000).limit(1000).pluck(:id)

    @hbnlist1 = Medium.where(media_group_id: 10000).limit(1000).pluck(:id)
    @hbnlist2 = Medium.where(media_group_id: 10000).offset(1000).limit(1000).pluck(:id)
    @hbnlist3 = Medium.where(media_group_id: 10000).offset(2000).limit(1000).pluck(:id)

    @paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000").select("id")
    @others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000").select("id")


  end

end
    #<%= render 'my_partial', :locals => {:greeting => 'Hello world', :x => 36} %>
    #<h1> <%= locals[:greeting] %> , my x value is <%= locals[:x] %> </h1>
    # add partial: to view info like
    #<%= render partial: 'my_partial', :locals => {:greeting => 'Hello world', :x => 36} %>
    #<h1> <%= greeting %> , my x value is <%= x %> </h1>
#     <td>
# <%= link_to "View", city_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>
# <td>
# <%= link_to "View", employee_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>
# <td>
# <%= link_to "View", hourly_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>

# <td>
# <%= link_to "View", channel_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>
# <td>
# <%= link_to "View", product_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>
# <td>
# <%= link_to "View", show_report_path(for_date: c[:for_date]), :target => "_blank" %>
# </td>
