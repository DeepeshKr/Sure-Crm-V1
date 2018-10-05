module SalesPpoTask
  def hello_time
  	time_now = (Time.zone.now + 330.minutes).strftime("%d-%b-%Y %H:%M")
    "hello the time now is #{time_now}"
  end
  
  def poco_add_product_to_campaign_hbn_ppo order_id
    #order_id = self.id
    # (order_id)
    #media_id
    message = ""
    order_master = OrderMaster.find(order_id)
    mediumid = order_master.media_id
    missed_reason = nil

    campaign_playlist_id = nil #order_master.campaign_playlist_id || 0 if order_master.campaign_playlist_id.present?
    product_variant = OrderLine.where(orderid: order_id).joins(:product_variant).where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_VARIANTS.product_sell_type_id = ?', 10000, 10040).order("PRODUCT_VARIANTS.product_sell_type_id ASC")
  
    product_variant_id = product_variant.first.productvariant_id || nil if product_variant.first.productvariant_id.present?
    
    return "No product variant found in order" if product_variant_id.blank?
    
    message += "\n Checking for ordered product: #{product_variant.first.description} in order ref #{order_id}"

    ext_product_code = ProductVariant.find(product_variant_id).extproductcode
    order_time = order_master.orderdate + 330.minutes
    nowhour = order_time.strftime('%H').to_i
    nowminute = order_time.strftime('%M').to_i
    todaydate = order_time.strftime("%Y-%m-%d")
    previous_date = (order_time - 1.day).strftime("%Y-%m-%d")
   # max_go_back_date = (todaydate.to_time - 48.hours).to_datetime
    nowsecs = (nowhour * 60 * 60) + (nowminute * 60)
    # check if media is part of HBN group
    # check if media is part of HBN group, if yes, update the HBN group
    # campaign playlist id both ways
    # on order and agains the campaign playlis
    if Medium.where(id: mediumid).present?
      channelname = Medium.find(mediumid).name
      media = Medium.find(mediumid)
      if (media.media_group_id != 10000 || media.media_group_id.blank?)
        order_master.update(campaign_playlist_id: nil)
        create_sales_hbn_ppo order_id
        remove_from_sales_ppo order_id
        return "NOT HBN Order removing from order master now"
      end
    end
    
   campaign_playlist = CampaignPlaylist.where(productvariantid: product_variant_id)
   .where(list_status_id: 10000)
   .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", nowsecs)
   .where("TRUNC(for_date) = ?", todaydate)
   .order("for_date DESC, start_hr DESC, start_min DESC")
   
   if campaign_playlist.present?

     # update order with campaign playlist id
     campaign_playlist_id = campaign_playlist.first.id if campaign_playlist.first.id.present?
     #order_master.update(campaign_playlist_id: campaign_playlist.first.id)

     message +=  "\n Step 1: #{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
     
     campaign_updated = "Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
     
   else
     message += "\n No recent campaign found for product variant id #{product_variant_id} when checked for #{nowsecs} sec for #{todaydate} => now will look for Extended campaign"
     
   end
   
    #check for additional product variants in extended file list start 
   if campaign_playlist_id.blank?
       
     extended_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
     .joins(:campaign_playlist)
     .where("campaign_playlists.list_status_id = 10000")
     .where("(campaign_playlists.start_hr * 60 * 60) + (campaign_playlists.start_min * 60) <= ?", nowsecs)
     .where("TRUNC(campaign_playlists.for_date) = ?", todaydate)
     .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
     campaign_playlists.start_min DESC")

    if extended_campaign_playlist.present?
      message += "\n Step 2: Found extended campaign playlist #{campaign_playlist_id} in updated order #{order_id}" 
      campaign_playlist_id = extended_campaign_playlist.first.campaign_playlist_id if extended_campaign_playlist.present?
      
    else
      message += "\n No EXTENDED recent campaign found for product variant id #{product_variant_id} when checked for #{nowsecs} sec for #{todaydate} => now will look for older campaigns"
      
    end      
   end
   
    ###############
    #####################
    # older date checks below
    #########################
   #update for earlier date playlists
   if !campaign_playlist_id.present?
     #this is designed for the playlist to go back as as required to assign this order for
     # now with no restrcitions to go back
     older_campaign_playlist = CampaignPlaylist.where(productvariantid: product_variant_id)
     .joins(:campaign).where("campaigns.mediumid = ?", 11200)
     .where("TRUNC(for_date) <= ?",  previous_date)
     .where(list_status_id: 10000)
     .order("for_date DESC, start_hr DESC, start_min DESC")
     
     if older_campaign_playlist.present?

        missed_reason = "\n Older campaign used Updated at #{order_time} order for #{channelname} with show #{older_campaign_playlist.name}
        (id #{older_campaign_playlist.first.id} ) at Hour:#{nowhour}  Minutes:#{nowminute}"

        #@order_master.update(campaign_playlist_id: older_campaign_playlist.first.id)
        campaign_playlist_id = older_campaign_playlist.first.id if older_campaign_playlist.first.id.present?

         message += "\n Step 3: #{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}" 

         campaign_updated = "\n Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}"  if older_campaign_playlist.present?
     end
   end
   
    # check for additional product variants for older campaign start
   if campaign_playlist_id.blank?
     extended_older_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
     .joins(:campaign_playlist)
     .where("campaign_playlists.list_status_id = 10000")
     .where("TRUNC(campaign_playlists.for_date) <= ?",  previous_date)
     .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
     campaign_playlists.start_min DESC")

        if extended_older_campaign_playlist.present? && campaign_playlist_id.blank?
         message += "\n Step 4: Found campaign playlist #{campaign_playlist_id} in Extended Older Playlist and update this for order #{order_id}" 
         campaign_playlist_id = extended_older_campaign_playlist.first.campaign_playlist_id if extended_older_campaign_playlist.present?
        end
   end
    # check for additional product variants for older campaign end

    if campaign_playlist_id.present?
      message += "\n Post-check-Exit: Found campaign playlist #{campaign_playlist_id} in older campaign and updated this for order #{order_id}" 
    else
      return "\n Exit: NO campaign playlist found in product campaign check" 
    end
    order_master.update(campaign_playlist_id: campaign_playlist_id)
    if campaign_playlist_id.present?
     # order_master.delay(:queue => 'hbn sales ppos over take', priority: 100).re_create_sales_ppo
      create_sales_hbn_ppo order_id
      message += "\n Process Completed - Updated"
    end
    
    return message
  end
  
  def create_sales_hbn_ppo order_id
    #create sales ppo for each order line
    order_master = OrderMaster.find(order_id)
    if order_master.medium.blank?
      return puts "Not a HBN Order, skipped!"
    end
    if order_master.medium.media_group_id != 10000
      return puts "Not a HBN Order, skipped!" 
    end
    # .where('ORDER_STATUS_MASTER_ID > 10002')
    if order_master.order_status_master_id < 10001
      return puts "Not a valid order, skipped!"
    end

    campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
    campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist
    campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
    order_pieces = order_master.pieces || 0 if order_master.pieces.present?
    if order_master.promotion.present?
      if order_master.promotion.promo_cost.present?
        total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
        per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
      end
    end

    order_lines = OrderLine.where(orderid: order_id)
    time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
    puts "Found #{order_lines.count()} orders, now checking if they are in PPO!"
    order_lines.each do |ordln|
    #add or update ppo details
    if SalesPpo.where(:order_line_id=> ordln.id).present?
      @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

      @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
        name: campaign_name,
        campaign_id: campaign_id,
        :product_master_id => ordln.product_master_id,
        product_variant_id: ordln.productvariant_id,
        product_list_id: ordln.product_list_id,
        prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
        :start_time => time_of_order,
        :order_id => ordln.orderid,
        :order_line_id=> ordln.id,
        :product_cost => ordln.productcost,
        :pieces => ordln.pieces,
        :revenue => ordln.productrevenue,
        :transfer_order_revenue => ordln.transfer_order_revenue,
        :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
        :damages => ordln.productcost * 0.10,
        :returns => ordln.refund,
        :commission_cost => ordln.variable_media_commission,
        :commission_on_order => ordln.fixed_media_commission,
        :promotion_cost=> per_order_promo_cost,
        :gross_sales => ordln.gross_sales,
        :net_sale => ordln.net_sales,
        :external_order_no => order_master.external_order_no,
        :order_status_id => order_master.order_status_master_id,
        :order_pincode => order_master.pincode,
        :media_id => order_master.media_id,
        :promo_cost_total => total_promotion_cost,
        :dnis => order_master.calledno,
        :city => order_master.city,
        :state => order_master.customer_address.state,
        :mobile_no => order_master.mobile,
        :shipping_cost => ordln.product_postage,
        payment_cost: ordln.financing_cost)

      puts "updated sales ppo"
      
      else
        @sale_ppo = SalesPpo.create(name: campaign_name,
        campaign_playlist_id: campaign_playlist_id,
        campaign_id: campaign_id,
        :product_master_id => ordln.product_master_id,
        product_variant_id: ordln.productvariant_id,
        product_list_id: ordln.product_list_id,
        prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
        :start_time => time_of_order,
        :order_id => ordln.orderid,
        :order_line_id => ordln.id,
        :product_cost => ordln.productcost,
        :pieces => ordln.pieces,
        :revenue => ordln.productrevenue,
        :transfer_order_revenue => ordln.transfer_order_revenue,
        :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
        :damages => ordln.productcost * 0.10,
        :returns => ordln.refund,
        :commission_cost => ordln.variable_media_commission,
        :commission_on_order => ordln.fixed_media_commission,
        :promotion_cost=> per_order_promo_cost,
        :gross_sales => ordln.gross_sales,
        :net_sale => ordln.net_sales,
        :external_order_no => order_master.external_order_no,
        :order_status_id => order_master.order_status_master_id,
        :order_pincode => order_master.pincode,
        :media_id => order_master.media_id,
        :promo_cost_total => total_promotion_cost,
        :dnis => order_master.calledno,
        :city => order_master.city,
        :state => order_master.customer_address.state,
        :mobile_no => order_master.mobile,
        :shipping_cost => ordln.product_postage,
        payment_cost: ordln.financing_cost)
        
        puts "Created sales ppo"
      end
    end
  end
  ####### to keep in syncs with older version #####
  def add_update order_id
    #create sales ppo for each order line
    order_master = OrderMaster.find(order_id)
    if order_master.medium.blank?
      return puts "Not a HBN Order, skipped!" 
    end
    if order_master.medium.media_group_id != 10000
      return puts "Not a HBN Order, skipped!" 
    end
    # .where('ORDER_STATUS_MASTER_ID > 10002')
    if order_master.order_status_master_id < 10001
      return puts "Not a valid order, skipped!" 
    end

    campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
    campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist
    campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
    order_pieces = order_master.pieces || 0 if order_master.pieces.present?
    if order_master.promotion.present?
      if order_master.promotion.promo_cost.present?
        total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
        per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
      end
    end

    order_lines = OrderLine.where(orderid: order_id)
    time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
    puts "Found #{order_lines.count()} orders, now checking if they are in PPO!" 
    order_lines.each do |ordln|
    #add or update ppo details
    if SalesPpo.where(:order_line_id=> ordln.id).present?
      @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

      @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
      name: campaign_name,
      campaign_id: campaign_id,
      :product_master_id => ordln.product_master_id,
      product_variant_id: ordln.productvariant_id,
      product_list_id: ordln.product_list_id,
      prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
      :start_time => time_of_order,
      :order_id => ordln.orderid,
      :order_line_id=> ordln.id,
      :product_cost => ordln.productcost,
      :pieces => ordln.pieces,
      :revenue => ordln.productrevenue,
      :transfer_order_revenue => ordln.transfer_order_revenue,
      :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
      :damages => ordln.productcost * 0.10,
      :returns => ordln.refund,
      :commission_cost => ordln.variable_media_commission,
      :commission_on_order => ordln.fixed_media_commission,
      :promotion_cost=> per_order_promo_cost,
      :gross_sales => ordln.gross_sales,
      :net_sale => ordln.net_sales,
      :external_order_no => order_master.external_order_no,
      :order_status_id => order_master.order_status_master_id,
      :order_pincode => order_master.pincode,
      :media_id => order_master.media_id,
      :promo_cost_total => total_promotion_cost,
      :dnis => order_master.calledno,
      :city => order_master.city,
      :state => order_master.customer_address.state,
      :mobile_no => order_master.mobile,
      :shipping_cost => ordln.product_postage)

      puts "updated sales ppo"
      
      else
        @sale_ppo = SalesPpo.create(name: campaign_name,
        campaign_playlist_id: campaign_playlist_id,
        campaign_id: campaign_id,
        :product_master_id => ordln.product_master_id,
        product_variant_id: ordln.productvariant_id,
        product_list_id: ordln.product_list_id,
        prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
        :start_time => time_of_order,
        :order_id => ordln.orderid,
        :order_line_id => ordln.id,
        :product_cost => ordln.productcost,
        :pieces => ordln.pieces,
        :revenue => ordln.productrevenue,
        :transfer_order_revenue => ordln.transfer_order_revenue,
        :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
        :damages => ordln.productcost * 0.10,
        :returns => ordln.refund,
        :commission_cost => ordln.variable_media_commission,
        :commission_on_order => ordln.fixed_media_commission,
        :promotion_cost=> per_order_promo_cost,
        :gross_sales => ordln.gross_sales,
        :net_sale => ordln.net_sales,
        :external_order_no => order_master.external_order_no,
        :order_status_id => order_master.order_status_master_id,
        :order_pincode => order_master.pincode,
        :media_id => order_master.media_id,
        :promo_cost_total => total_promotion_cost,
        :dnis => order_master.calledno,
        :city => order_master.city,
        :state => order_master.customer_address.state,
        :mobile_no => order_master.mobile,
        :shipping_cost => ordln.product_postage)
        
         puts "Created sales ppo"
      end
    end
  end
    ####### to keep in syncs with older version #####
  def remove_from_sales_ppo order_id
    order_master = OrderMaster.find(order_id)

    order_lines = OrderLine.where(orderid: order_id)
    order_lines.each do |ordln|
    #add or update ppo details
      if SalesPpo.where(:order_line_id=> ordln.id).present?
        sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first
        sale_ppo.destroy
        puts "Destroyed for order id #{order_master.id}"
      end
    end
  end
  
  def missed_orders_for_date for_date
     
    all_missed_orders = OrderMaster.where("TRUNC(orderdate) = ?", for_date)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .joins(:medium).where("media.media_group_id = 10000")
          
    total_missed_order_count = 0
    
    if all_missed_orders.present?
      
      puts "Checking on all #{all_missed_orders.count} orders for #{for_date}"

      all_missed_orders.each do |missed|
        #check if the order is present in sales ppo and proceed further
        sales_ppo_check =  SalesPpo.find_by_order_id(missed.id)
        if sales_ppo_check.blank?
          add_product_to_campaign_hbn_ppo missed.id
          total_missed_order_count += 1
        end
         
      end
    end
    puts "Completed PPO missed order checks for #{all_missed_orders.count} orders of #{for_date} and processed #{total_missed_order_count} missed orders"
  end
  
end