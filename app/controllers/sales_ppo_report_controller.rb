class SalesPpoReportController < ApplicationController
  before_action { protect_controllers(5) }
  before_action :media_segments, only: [:daily,  :show, :channel]
  before_action :constants
  before_action :hbn_fixed_costs, only: [:summary , :hourly, :hour_performance, :product_performance, :product_hour_performance, :operator_performance, :show, :ppo_products, :channel]

  require 'will_paginate/array'
  def summary
    @sno = 1
    @searchaction = "summary"
    @datelist ||= []
    employeeunorderlist ||= []

    #Medium.where(media_commision_id: 10045)
    @hbn_media = Medium.where(media_group_id: 10000, active: true, media_commision_id: 10000)

    if params.has_key?(:for_date)
          for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")

          @from_date = for_date.to_date - 0.days #30.days
          @up_to_date = for_date.to_date
    else
      return
    end

    @up_to_date.downto(@from_date).each do |day|
           # day = day - 330.minutes
          @datelist <<  day.strftime('%y-%b-%d')

          for_date = day # Date.
          @or_for_date = for_date

          @from_date = for_date.beginning_of_day - 330.minutes
          @to_date = for_date.end_of_day - 330.minutes

          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          .where('orderdate >= ? AND orderdate <= ?', @from_date, @to_date)
           .joins(:medium).where("media.media_group_id = 10000") #.limit(1)

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


          # nos =  nos * @correction
          # pieces = pieces * @correction

          # # #product_cost = product_cost * nos
          # product_cost = (product_cost * @correction)
          # product_damages = (product_cost * 0.10)
          # totalorders = totalorders * @correction

          # refund = totalorders * 0.02

          ## Apply all the corrections here ###
          total_shipping = (orderlist.sum(:shipping))
          total_sub_total = (orderlist.sum(:subtotal))
          totalorders = (total_shipping + total_sub_total)


           ## Apply all the corrections here ###
          revenue = revenue * @correction
          media_var_cost = media_var_cost * @correction
          product_cost = product_cost * @correction
          product_damages = (product_cost * 0.10)
          totalorders = totalorders * @correction
          refund = totalorders * 0.02
          nos = (orderlist.count()) * @correction
          pieces = orderlist.sum(:pieces) * @correction
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

  def hourly
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
            csv_file_name = "half_hourly_summary_#{@or_for_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
    @list_of_orders =  @list_of_orders.sort_by{ |c| c[:time_of_order]}
  end

  def corrected_date_time(for_date, for_hour, for_minute)
    for_hour = for_hour.to_s.rjust(2, '0')
    for_minute = for_minute.to_s.rjust(2, '0')
    for_date = for_date.strftime("%Y-%m-%d")
    #string_date = for_date + " " + for_hour + ":" + for_minute + ":00"
    base_date = DateTime.strptime("#{for_date} #{for_hour}:#{for_minute}:00 + 5:30", "%Y-%m-%d %H:%M:%S")
    #return return_date = DateTime.strptime(string_date, "%Y-%m-%d %H:%M:%S")
    return (base_date - 300.minutes).strftime("%Y-%m-%d %H:%M:%S")

  end

  def hour_performance
    @hbn_media_cost_master = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"

     for_date = (330.minutes).from_now.to_date
     @from_date = (330.minutes).from_now.to_date
     if params.has_key?(:time_id)
       @time_id = params[:time_id]
       @time_slot = MediaCostMaster.find(@time_id)
       @start_hr = @time_slot.str_hr
       @start_min = @time_slot.str_min
       @start_total_secs = (@start_hr * 60) + (@start_min)
       @end_hr = @time_slot.end_hr
       @end_min = @time_slot.end_min
       @end_total_secs = (@end_hr * 60) + (@end_min)
     end
     if params.has_key?(:from_date)
        @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
        @or_for_date = for_date.strftime("%Y-%m-%d")
     end
     @to_date = (330.minutes).from_now.to_date
     if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
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
        @total_damages = 0
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
          orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002') .joins(:medium).where("media.media_group_id = 10000").where('orderdate >= ? AND orderdate <= ?',  @from_date, @to_date)

           campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", @from_date, @to_date)
           .where("(start_hr * 60) + (start_min) >= ? AND ((start_hr * 60) + start_min) <= ?", @start_total_secs, @end_total_secs)
           .where(list_status_id: 10000).order("for_date, start_hr, start_min")#.limit(15)


           campaign_playlists.each do | playlist |
           orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
           .where(campaign_playlist_id: playlist.id)

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

        @employeeorderlist = employeeunorderlist #.sort_by{|c| c[:total]}.reverse
          respond_to do |format|
            csv_file_name = "Performance_from_#{@str_hr}_#{@str_min}_to_#{@end_hr}_#{@end_min}_between_#{@from_date}_ #{@to_date}.csv"
              format.html
              format.csv do
                headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
                headers['Content-Type'] ||= 'text/csv'
          end
        end
  end

  def product_performance
    @report_results = "Please select date range to show report"
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"
     @from_date = (330.minutes).from_now.to_date
     for_date = (330.minutes).from_now.to_date
     @product_lists = ProductList.joins(:product_variant).where("product_variants.activeid = 10000").order('product_lists.name')

     @product_variants = ProductVariant.all.order("name").where("activeid = 10000")

     if params.has_key?(:product_variant_id)
      @product_variant_id = params[:product_variant_id]
      @product_variant = ProductVariant.find(@product_variant_id)
     end
     if params.has_key?(:product_list_id)
      @product_list_id = params[:product_list_id]
      @product_list = ProductList.find(@product_list_id)
     end
     if params.has_key?(:from_date)
      @from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @or_for_date = for_date.strftime("%Y-%m-%d")
     end
     @to_date = (330.minutes).from_now.to_date
     if params.has_key?(:to_date)
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
     end
    #  if @product_variant_id == nil && @from_date == nil && @to_date == nil
    #    return
    #  end
     if @product_list_id == nil && @from_date == nil && @to_date == nil
       return
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
        @total_damages = 0
        @total_ppo = 0
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
           campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", @from_date, @to_date).where(list_status_id: 10000).order("for_date, start_hr, start_min")
           @total_fixed_cost = campaign_playlists.sum(:cost).to_f

           campaign_playlists.each do | playlist |

          #  @orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
          #  .where(campaign_playlist_id: playlist.id).joins(:order_line)
          #  .where("order_lines.product_list_id in (?)", @product_list_id)
          #  .pluck(:id)

           @orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
           .where(campaign_playlist_id: playlist.id).joins(:order_line)
           .where("order_lines.productvariant_id in (?)", @product_variant_id)
           .pluck(:id)
           #.limit(10)
             @correction = 0.5
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

  def product_hour_performance
    @hbn_media_cost_master = MediaCostMaster.where(media_id: 11200).order("str_hr, str_min")
    @hourlist = "Time UTC is your zone #{Time.zone.now} while actual time is #{Time.now}"
    @sno = 1
    @searchaction = "hourly"

     for_date = (330.minutes).from_now.to_date
     @from_date = (330.minutes).from_now.to_date
     if params.has_key?(:time_id)
       @time_id = params[:time_id]
       @time_slot = MediaCostMaster.find(@time_id)
       @start_hr = @time_slot.str_hr
       @start_min = @time_slot.str_min
       @end_hr = @time_slot.end_hr
       @end_min = @time_slot.end_min
     end
     @product_variants = ProductVariant.all.order("name")
     if params.has_key?(:product_variant_id)
        @product_variant_id = params[:product_variant_id]
        @product_name = ProductVariant.find(@product_variant_id)
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
           campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", @from_date, @to_date)
           .where("start_hr >= ? AND start_min >= ? AND start_hr <= ? AND start_min <= ?", @start_hr, @start_min, @end_hr, @end_min)
           .where(list_status_id: 10000).order("for_date, start_hr, start_min")
           #.limit(150)

           @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
           @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f
           @total_fixed_cost = campaign_playlists.sum(:cost).to_f

           campaign_playlists.each do | playlist |
           orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
           .where(campaign_playlist_id: playlist.id).joins(:order_line)
           .where("order_lines.productvariant_id = ?", @productvariant_id)

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

  def hour_sales_performance
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

      @from_time = corrected_date_time(day, @start_hr, @start_min)
      @upto_time = corrected_date_time(day, @end_hr, @end_min)

      orderlists = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
      .joins(:medium).where("media.media_group_id = 10000")
      .where('orderdate >= ? AND orderdate <= ?', @from_time, @upto_time)

      halfhourlist ||= []
        orderlists.each do |order_list|
          campaign_name = order_list.campaign_playlist.playlist_details + " " + order_list.campaign_playlist.starttime if order_list.campaign_playlist

          products = ""
          #cats.each do |cat| cat.name end
          if order_list.order_line.present?
            #products = o.order_line.each(&:description)
            order_list.order_line.each do |ord| products << ord.description end
          end
          order_time = (order_list.orderdate + 300.minutes).strftime("%H:%M")
          halfhourlist << {
            :campaign => campaign_name,
            :products => products,
            :order_time => order_time,
            :order_id => order_list.external_order_no
          }
        end
      total_order_nos = orderlists.count(:id)
      total_order_value = orderlists.sum(:g_total).round(0)
      s_no_i = 1

      #campaign_playlists.each do | playlist |

            #  campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", @from_date, @to_date)
            #  .where("start_hr >= ? AND start_min >= ? AND start_hr <= ? AND start_min <= ?", @start_hr, @start_min, @end_hr, @end_min)
            #  .where(list_status_id: 10000).order("for_date, start_hr, start_min")
             #.limit(150)


          employeeunorderlist << {
            :order_date => (DateTime.strptime(@from_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%Y-%m-%d"),
            :time_start => (DateTime.strptime(@from_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%H:%M"),
            :time_end => (DateTime.strptime(@upto_time, "%Y-%m-%d %H:%M:%S") + 300.minutes).strftime("%H:%M"),
            :total_nos => total_order_nos,
            :total_value => total_order_value,
            :hourlist => halfhourlist
          }

          @employeeorderlist = employeeunorderlist
          # respond_to do |format|
          #   csv_file_name = "Hour_Sales_between_#{@from_date}_ #{@to_date}.csv"
          #     format.html
          #     format.csv do
          #       headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
          #       headers['Content-Type'] ||= 'text/csv'
          # end
          # end
      end
  end

  def operator_performance
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
        @total_expenses = 0
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

  def show

    @searchaction = "show"
    for_date = (330.minutes).from_now.to_date
    to_date = for_date + 1.day
    if params.has_key?(:for_date)
     for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
     @from_date = for_date.beginning_of_day - 330.minutes
     @to_date = for_date.end_of_day - 330.minutes
     @or_for_date = for_date.strftime("%Y-%m-%d")
    end
    @sno = 1
        @hourlist ||= []
        employeeunorderlist ||= []

      @total_nos = 0
      @total_pieces = 0
      @total_sales = 0
      @total_revenue = 0
      @total_product_cost = 0
      @total_var_cost = 0
      @total_fixed_cost = 0
      @total_cost = 0
      @total_refund = 0
      @total_damages = 0
      @total_profit = 0

      #@for_date = @campaign.startdate
     campaign_playlists =  CampaignPlaylist.joins(:campaign)
     .where("campaigns.startdate = ?", for_date)
     .order(:start_hr, :start_min, :start_sec)
     .where(list_status_id: 10000) #.limit(5)

    #  @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
    #  @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f
     @total_fixed_cost = campaign_playlists.sum(:cost).to_f
      secs_in_a_day = (24*60*60)
      media_cost = @hbn_media_cost / secs_in_a_day

      @serial_no = 1
     campaign_playlists.each do | playlist |
     orderlist = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
     .where(campaign_playlist_id: playlist.id)

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

          employeeunorderlist << {:serial_no => @serial_no,
            :show =>  playlist.product_variant.name,
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
          :profitability => profitability,
          :product_variant_id => playlist.productvariantid}

         @serial_no += 1
        end
        @employeeorderlist = employeeunorderlist
      #@employeeorderlist = @employeeorderlist.paginate(:page => params[:page])
        respond_to do |format|
        csv_file_name = "show_ppo_#{for_date}.csv"
          format.html
          format.csv do
            headers['Content-Disposition'] = "attachment; filename=\"#{csv_file_name}\""
            headers['Content-Type'] ||= 'text/csv'
          end
        end

   #xcel download
  end

  def ppo_products
    if params.has_key?(:campaign_id)
      @total_nos = 0
      @total_pieces = 0
      @total_subtotal = 0
      @total_shipping = 0
      @total_sales = 0
      @total_revenue = 0
      @total_product_cost = 0
      @total_var_cost = 0
      @total_fixed_cost = 0
      @total_cost = 0
      @total_refund = 0
      @total_profit = 0
      @cost_per_order = 0
      @profit_per_order = 0
      @total_promo_cost = 0

      @campaign_playlist =  CampaignPlaylist.find(params[:campaign_id])
      @order_masters = OrderMaster.where(campaign_playlist_id: params[:campaign_id]).where('ORDER_STATUS_MASTER_ID > 10002').order("created_at")

      start_hr = @campaign_playlist.start_hr
      start_min = @campaign_playlist.start_min
      # @show_for_date = (@campaign_playlist.for_date + 330.minutes).beginning_of_day

      #show_for_date = for_date
      # .where("order_lines.orderdate.hour >= ? and orderlines.orderdate.min >= ?", start_hr, start_min)
      #  @ordered_product_list = OrderLine.where(productvariant_id: @campaign_playlist.productvariantid)
      #  .where("TRUNC(order_lines.orderdate) >= ?", @show_for_date )
      # .where("order_lines.orderdate <= ?", @campaign_playlist.for_date + 3.days)
      #  .joins(:order_master).where("order_masters.ORDER_STATUS_MASTER_ID > 10002")
      #  .order("order_lines.created_at")
      #  t = (330.minutes).from_now #Time.zone.now + 330.minutes
      #     @nowhour = t.strftime('%H').to_i
      #     @nowminute = t.strftime('%M').to_i
      # @nowsecs = (@nowhour * 60 * 60) + (@nowminute * 60)
      # #@startsecs = ((@start_time.hour) * 60 * 60) + ((@start_time.min) * 60)

      # @all_campaign_playlists = CampaignPlaylist.where(list_status_id: 10000)
      # .where(productvariantid: @campaign_playlist.productvariantid)
      #       .where("TRUNC(for_date) =  ?", @campaign_playlist.for_date)
      #       .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", @nowsecs)
      #       .order("start_hr DESC, start_min DESC")


        @order_masters.each do |order |
            @total_nos += 1
            @total_pieces += order.pieces
            @total_subtotal += order.subtotal
            @total_shipping += order.shipping
            @total_sales += order.total
            @total_revenue += order.productrevenue

            @total_product_cost += order.productcost
            @total_var_cost += order.media_commission
            if order.promotion.present?
              @total_promo_cost += order.promotion.promo_cost
            end



        end
        # All Costs
        @total_refund = @total_sales * 0.02
        @total_fixed_cost = @campaign_playlist.cost
        @total_product_dam_cost  = @total_product_cost * 0.10

        @total_cost_per_order = (@total_product_cost  + @total_var_cost +  @total_refund + @total_promo_cost + @total_product_dam_cost + @total_fixed_cost)

        @cost_per_order = (@total_cost_per_order) / @total_nos
        @total_profit = @total_revenue - @total_cost_per_order
        @profit_per_order = @total_profit / @total_nos

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
         @cost_per_order_60 = (@total_cost_per_order_60) / @total_nos_60
         @total_profit_60 = @total_revenue_60 - @total_cost_per_order_60
         @profit_per_order_60 = @total_profit_60 / @total_nos_60

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

         @cost_per_order_50 = (@total_cost_per_order_50) / @total_nos_50
         @total_profit_50 = @total_revenue_50 - @total_cost_per_order_50
         @profit_per_order_50 = @total_profit_50 / @total_nos_50

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

         @cost_per_order_40 = (@total_cost_per_order_40) / @total_nos_40
         @total_profit_40 = @total_revenue_40 - @total_cost_per_order_40
         @profit_per_order_40 = @total_profit_40 / @total_nos_40


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

    end
    #populate sales information


    #end of class
  end

  def ppo_details
    @sno = 1
    between_time
    hbn_channels_between
    shows_between
    showproducts
  end


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
           .joins(:medium).where("media.media_group_id = 10000")
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



        hbn_order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10002')
        .where('orderdate >= ? AND orderdate <= ?', @start_time, @end_time)
         .joins(:medium).where("media.media_group_id = 10000")
         .select(:media_id).distinct

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

        @hbn_order_list = hbn_order_list.sort_by{|c| c[:total]}.reverse


    end


  end

  def shows_between
      for_date = (330.minutes).from_now.to_date

      if params.has_key?(:for_date)
       for_date =  Date.strptime(params[:for_date], "%Y-%m-%d")
      end

      #media segregation only HBN
      #media_segments

      @show_date = for_date.strftime("%d-%b-%Y")
       campaigns = Campaign.joins(:medium).where("media.media_group_id = 10000").pluck(:id)

      if params.has_key?(:start_time) && params.has_key?(:end_time)

         @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M")
          @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M")

          @startsecs = ((@start_time.hour) * 60 * 60) + ((@start_time.min) * 60)
          if @start_time.hour <= 4
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
           .where('campaignid IN (?)', campaigns)
          .order(:start_hr, :start_min, :start_sec).where(list_status_id: 10000)

            @startsecs = 0
          else

            @start_time = Time.strptime(params[:start_time], "%Y-%m-%d %H:%M")
            @end_time = Time.strptime(params[:end_time], "%Y-%m-%d %H:%M")

            @start_time = @start_time - 4.hours
            @end_time = @end_time


          end


        @Show_start_time = @start_time.strftime("%H:%M") || 0
        @Show_end_time = @end_time.strftime("%H:%M") || 0

        # @campaign_playlists =  CampaignPlaylist.where(list_status_id: 10000).limit(10)

        @endsecs = (@end_time.hour * 60 * 60) + (@end_time.min * 60)

         @campaign_playlists =  CampaignPlaylist.where("(start_hr * 60 * 60) + (start_min * 60) >= ? and (start_hr * 60 *60 )  + (start_min *60) <= ?", @startsecs, @endsecs)
         .joins(:campaign).where("campaigns.startdate = ?", for_date)
         .where('campaignid IN (?)', campaigns)
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
        .where("media.media_group_id = 10000").pluck(:id)


        total_order_summary(order_masters, @start_time, @end_time )
        regular_product_variant_list = ProductVariant.where(product_sell_type_id: 10000)

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
     @correction = 0.5
     @shipping_tax_less = 0.98125
     @subtotal_vat_less = 0.888889
  end

  def media_segments
    @hbnlist1 = Medium.where(media_group_id: 10000).limit(1000).pluck(:id)
    @hbnlist2 = Medium.where(media_group_id: 10000).offset(1000).limit(1000).pluck(:id)
    @hbnlist3 = Medium.where(media_group_id: 10000).offset(2000).limit(1000).pluck(:id)
    @paid = Medium.where(media_commision_id: 10000).where("media_group_id IS NULL OR media_group_id <> 10000").select("id")
    @others = Medium.where('media_commision_id IS NULL').where("media_group_id IS NULL OR media_group_id <> 10000").select("id")

  end

  def hbn_fixed_costs
    #  @fixed_cost = Medium.where(media_group_id: 10000, active: true, media_commision_id: 10045).sum(:daily_charges).to_f

    @all_fixed_media  = Medium.where(media_commision_id: 10000)
    @hbn_media = @all_fixed_media.where(media_group_id: 10000, active: true, media_commision_id: 10000)
    @total_media_cost = @all_fixed_media.sum(:daily_charges).to_f
    @hbn_media_fixed_cost = @hbn_media.sum(:daily_charges).to_f
    @hbn_media_cost = @hbn_media_fixed_cost.round(2)
    @fixed_cost = @hbn_media.sum(:daily_charges).to_f
    #
    #  @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
    #
    #  @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f

    #  @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
    #  @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f

            #  @total_media_cost = Medium.where(media_group_id: 10000).sum(:daily_charges).to_f
            #  @hbn_media_cost = Medium.where(media_group_id: 10000, active: true).sum(:daily_charges).to_f
            #  @total_fixed_cost = campaign_playlists.sum(:cost).to_f
  end
end
