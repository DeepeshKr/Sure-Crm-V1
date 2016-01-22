module CreatePpo

  def add_update order_id
      #create sales ppo for each order line
      order_master = OrderMaster.find(order_id)

      if order_master.medium.media_group_id != 10000
        return puts "Not a HBN Order, skipped!"
      end

      campaign_playlist =  CampaignPlaylist.find(order_master.campaign_playlist_id)
      @fixed_cost = campaign_playlist.cost

      order_pieces = order_master.pieces || 0 if order_master.pieces.present?
      if order_master.promotion.present?
        if order_master.promotion.promo_cost.present?
          total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
          per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
        end
      end

      order_lines = OrderLine.where(orderid: order_id)
      time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')

      order_lines.each do |ordln|
      #add or update ppo details
      if SalesPpo.where(:order_line_id=> ordln.id).present?
        @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).present?

        @sale_ppo.update(:campaign_playlist_id => order_master.campaign_playlist_id,
        :campaign_id => order_master.campaign_playlist.campaign_id,
        :product_master_id => ordln.product_master_id,
        product_variant_id: ordln.productvariant_id,
        product_list_id: ordln.product_list_id,
        prod: ordln.product_list.extproductcode,
        :name=> "", :start_time => time_of_order,
        :order_id => ordln.orderid,
        :order_line_id=> ordln.id,
        :product_cost => ordln.productcost, :pieces => ordln.pieces,
        :revenue => ordln.productrevenue,
        :damages => ordln.product_cost * 0.10,
        :returns => ordln.refund,
        :commission_cost => ordln.media_commission,
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
        :mobile_no => order_master.mobile)

          return puts "Updated existing Sales PPO with id #{@sale_ppo.id} created on #{sale_ppo.created_at.strftime("%d-%b-%y %H:%M")}"
        else
          # :
          #
          @sale_ppo = SalesPpo.create(:name => "",
          :campaign_playlist_id => order_master.campaign_playlist_id,
          :campaign_id => order_master.campaign_playlist.campaignid,
          :product_master_id => ordln.product_master_id,
          product_variant_id: ordln.productvariant_id,
          product_list_id: ordln.product_list_id,
          prod:ordln.product_list.extproductcode,
          :start_time => time_of_order,
          :order_id => ordln.orderid,
          :order_line_id => ordln.id,
          :product_cost => ordln.productcost, :pieces => ordln.pieces,
          :revenue => ordln.productrevenue,
          :damages => ordln.productcost * 0.10,
          :returns => ordln.refund,
          :commission_cost => ordln.media_commission,
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
          :mobile_no => order_master.mobile)

          return puts "Create new Sales PPO with id #{@sale_ppo.id}"
        end
      end
    end

end
