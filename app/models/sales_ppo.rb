class SalesPpo < ActiveRecord::Base
  require 'csv'
  require 'bigdecimal'
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  belongs_to :order_status_master, foreign_key: "order_status_id"
  has_many :campaign, foreign_key: "campaign_id"
  belongs_to :order_master, foreign_key: "order_id"
  belongs_to :order_line, foreign_key: "order_line_id"
  belongs_to :medium, foreign_key: "media_id"
  belongs_to :promotion, foreign_key: "promotion_id"
  belongs_to :product_master, foreign_key: "product_master_id"
  belongs_to :product_variant, foreign_key: "product_variant_id"
  belongs_to :product_list, foreign_key: "product_list_id"

  validates :order_line_id,  allow_blank: true, uniqueness: true
  validates_presence_of :campaign_playlist_id

  attr_accessor :ppo_details, :total_sales, :total_revenue, :total_nos, :total_pieces,
  :total_product_cost, :total_product_dam_cost,
  :def_retail, :def_transfer,
  :total_refund, :total_promo_cost, :total_var_cost, :total_var_on_order_cost, :total_cost_per_order,
  :cost_per_order, :total_profit, :profit_per_order,
  :shipping_cost, :correction, :postage_name, :cor_total_nos,
  :total_name, :demo_date, :description, :for_date,
  :total_fixed_cost, :cor_fixed_cost,
  :show, :show_time, :total_nos_1, :total_pieces_1,:total_sales_1, :total_revenue_1, :total_product_cost_1,  :total_var_cost_1,:total_var_on_order_cost_1,
  :total_fixed_cost_1, :total_refund_1, :total_product_dam_cost_1, :profit_per_order_1, :total_name_1,
  :total_nos_2, :total_pieces_2,:total_sales_2, :total_revenue_2, :total_product_cost_2, :total_var_cost_2,
  :total_var_on_order_cost_2, :total_fixed_cost_2,  :total_refund_2, :total_product_dam_cost_2, :profit_per_order_2, :total_name_2,
  :total_nos_3, :total_pieces_3, :total_sales_3, :total_revenue_3, :total_product_cost_3, :total_var_cost_3,
  :total_var_on_order_cost_3, :total_fixed_cost_3, :total_refund_3, :total_product_dam_cost_3, :profit_per_order_3, :total_name_3

  attr_accessor :all_orders, :retail_orders, :shipped_orders, :transfer_orders, :open_orders, :sim_product_cost, :sim_retail_sales_pieces, :sim_to_sales_pieces, :sim_product_total

  def change_ppo_product_costs order_id = 0
     order_id = self.order_id if order_id == 0
   #order_id = self.order_id
       #create sales ppo for each order line
       order_master = OrderMaster.find(order_id)
   #order_id = self.order_id
       #create sales ppo for each order line
       return  puts "No campaign playlist found in PPO"  if order_master.campaign_playlist_id.blank?

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
     puts "Found #{order_lines.count()} orders, now checking if they are in PPO!" #.colorize(:blue)
     order_lines.each do |ordln|
     #add or update ppo details
     #byebug
     if SalesPpo.where(:order_line_id => ordln.id ).present?
       sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

       sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
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
       :mobile_no => order_master.mobile,
       :shipping_cost => ordln.product_postage)

       puts "Updated existing Sales PPO with id #{sale_ppo.id} created on #{sale_ppo.created_at.strftime("%d-%b-%y %H:%M")} for order id #{order_id}" #.colorize(:light_yellow).colorize( :background => :black)
       end
     end
  end
  handle_asynchronously :change_ppo_product_costs

  def ppo_details campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results

      sales_ppo = SalesPpo.new
      # campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
      sales_ppo = calculate_campaign_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
      return sales_ppo
  end

  def ppo_product_details campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results, product_variant_id

      sales_ppo = SalesPpo.new
      # campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
      sales_ppo = calculate_product_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results, product_variant_id
      return sales_ppo
  end

  def sales_ppos_between_dates from_date, to_date, ret_def = 0, to_def = 0
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value
    retail_def = ret_def.to_f if ret_def.to_i > 0
    transfer_def = to_def.to_f if to_def.to_i > 0

    campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", from_date, to_date)
           .where(list_status_id: 10000)
           .order("for_date, start_hr, start_min, start_sec")

           combined_fixed_cost = campaign_playlists.sum(:cost).to_f

           combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?



    to_date.downto(from_date).each do |day|
    sales_ppo_1 = daily_campaign_ppo day, true, false, retail_def, transfer_def, "all"

    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    #ret_sales_ppo.product_variant_id = sales_ppo_1.productvariantid
    ret_sales_ppo.for_date = day
    #ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    #ret_sales_ppo.show = playlist.product_variant.name
    #ret_sales_ppo.show_time = playlist.starttime

    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_var_on_order_cost_1 = sales_ppo_1.total_var_on_order_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order


    ret_sales_ppo.description = "R=> #{retail_def}: T=>#{transfer_def}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  def sales_ppos_for_date for_date, ret_def = 0, to_def = 0
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value
    retail_def = ret_def.to_f if ret_def.to_i > 0
    transfer_def = to_def.to_f if to_def.to_i > 0

    campaign_playlists =  CampaignPlaylist.joins(:campaign)
    .where("campaigns.startdate = ?", for_date)
    .order(:start_hr, :start_min, :start_sec)
    .where(list_status_id: 10000)

    combined_fixed_cost = campaign_playlists.sum(:cost).to_f

    combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?


   campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new


    rate_best_of_threes = return_rate.retail_best_of_three(playlist.productvariantid, campaign.mediumid)
    rate_best_of_three = rate_best_of_threes.first
    #campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
    sales_ppo_1 = calculate_campaign_ppo playlist.id, true, false, rate_best_of_three.rate, 65.0, "all"
    sales_ppo_2 = calculate_campaign_ppo(playlist.id, true, false, retail_def, transfer_def,"all")
    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    ret_sales_ppo.for_date = playlist.for_date
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{rate_best_of_three.rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.show = playlist.product_variant.name
    ret_sales_ppo.show_time = playlist.starttime

    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_var_on_order_cost_1 = sales_ppo_1.total_var_on_order_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order

    ret_sales_ppo.total_nos_2 = sales_ppo_2.total_nos
    ret_sales_ppo.total_pieces_2 = sales_ppo_2.total_pieces
    ret_sales_ppo.total_sales_2 = sales_ppo_2.total_sales
    ret_sales_ppo.total_revenue_2 = sales_ppo_2.total_revenue
    ret_sales_ppo.total_product_cost_2 = sales_ppo_2.total_product_cost
    ret_sales_ppo.total_var_cost_2 = sales_ppo_2.total_var_cost
    ret_sales_ppo.total_var_on_order_cost_2 = sales_ppo_2.total_var_on_order_cost
    ret_sales_ppo.total_fixed_cost_2 = sales_ppo_2.total_fixed_cost
    ret_sales_ppo.total_refund_2 = sales_ppo_2.total_refund
    ret_sales_ppo.total_product_dam_cost_2 = sales_ppo_2.total_product_dam_cost
    ret_sales_ppo.profit_per_order_2 = sales_ppo_2.profit_per_order



    ret_sales_ppo.description = "R-1: #{rate_best_of_three.note} @ #{rate_best_of_three.rate.round(1)}| R-2:  #{sales_ppo_2.correction}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  def sales_show_ppos_for_date from_date, to_date, product_variant_id, ret_def = nil, to_def = nil, product_cost = nil
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value

    retail_def = ret_def.to_f if ret_def.present?
    transfer_def = to_def.to_f if to_def.present?
    ### product_variant_ids
    product_variant_ids = []
    product_variant_ids << product_variant_id
    # if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(campaign_playlist_id).present?)
    #   product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id: campaign_playlist_id).pluck(:product_variant_id)
    # end
    ### product_variant_ids
    campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", from_date, to_date)
           .where(productvariantid: product_variant_ids)
           .where(list_status_id: 10000)
           .order("for_date, start_hr, start_min, start_sec")

           return if campaign_playlists.blank?

           combined_fixed_cost = campaign_playlists.sum(:cost).to_f

           combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?


   campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new


    rate_best_of_threes = return_rate.retail_best_of_three(playlist.productvariantid, campaign.mediumid)
    rate_best_of_three = rate_best_of_threes.first
    #campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
    sales_ppo_1 = calculate_campaign_ppo playlist.id, true, false, rate_best_of_three.rate, 65.0, "all"
    sales_ppo_2 = calculate_campaign_ppo(playlist.id, true, false, retail_def, transfer_def,"all")
    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    ret_sales_ppo.for_date = playlist.for_date
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{rate_best_of_three.rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.show = playlist.product_variant.name
    ret_sales_ppo.show_time = playlist.starttime

    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order

    ret_sales_ppo.total_nos_2 = sales_ppo_2.total_nos
    ret_sales_ppo.total_pieces_2 = sales_ppo_2.total_pieces
    ret_sales_ppo.total_sales_2 = sales_ppo_2.total_sales
    ret_sales_ppo.total_revenue_2 = sales_ppo_2.total_revenue
    ret_sales_ppo.total_product_cost_2 = sales_ppo_2.total_product_cost
    ret_sales_ppo.total_var_cost_2 = sales_ppo_2.total_var_cost
    ret_sales_ppo.total_fixed_cost_2 = sales_ppo_2.total_fixed_cost
    ret_sales_ppo.total_refund_2 = sales_ppo_2.total_refund
    ret_sales_ppo.total_product_dam_cost_2 = sales_ppo_2.total_product_dam_cost
    ret_sales_ppo.profit_per_order_2 = sales_ppo_2.profit_per_order



    ret_sales_ppo.description = "R-1: #{rate_best_of_three.note} @ #{rate_best_of_three.rate.round(1)}| R-2:  #{sales_ppo_2.correction}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  # used by product ppo controler
  #:sim_product_cost, :sim_retail_sales_pieces, :sim_to_sales_pieces, :sim_product_total
  def sales_product_ppos_for_date from_date, to_date, product_variant_id, ret_def = 0, to_def = 0, sim_product_cost = 0, sim_retail_sales_pieces = 0, sim_to_sales_pieces = 0, sim_product_total = 0
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value

    retail_def = ret_def.to_f if ret_def.to_i > 0
    transfer_def = to_def.to_f if to_def.to_i > 0
    ### product_variant_ids
    product_variant_ids = []
    product_variant_ids << product_variant_id
    # if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(campaign_playlist_id).present?)
    #   product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id: campaign_playlist_id).pluck(:product_variant_id)
    # end
    ### product_variant_ids
    campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", from_date, to_date)
           .where(productvariantid: product_variant_ids)
           .where(list_status_id: 10000)
           .order("for_date, start_hr, start_min")

      return if campaign_playlists.blank?

      combined_fixed_cost = campaign_playlists.sum(:cost).to_f
      combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?

    #combined_fixed_cost = campaign_playlists.sum(:cost).to_f
    campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new


    rate_best_of_threes = return_rate.retail_best_of_three(playlist.productvariantid, campaign.mediumid)
    rate_best_of_three = rate_best_of_threes.first
    #campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
    sales_ppo_1 = calculate_product_ppo playlist.id, true, false, rate_best_of_three.rate, 65.0, "all", product_variant_id
    #, sim_product_cost, sim_retail_sales_pieces, sim_to_sales_pieces, sim_product_total
    sales_ppo_2 = calculate_product_ppo playlist.id, true, false, retail_def, transfer_def, "all", product_variant_id
    #, sim_product_cost, sim_retail_sales_pieces, sim_to_sales_pieces, sim_product_total
    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    ret_sales_ppo.for_date = playlist.for_date
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{rate_best_of_three.rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.show = playlist.product_variant.name
    ret_sales_ppo.show_time = playlist.starttime

    # row 1
    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order
    # row 2
    ret_sales_ppo.total_nos_2 = sales_ppo_2.total_nos
    ret_sales_ppo.total_pieces_2 = sales_ppo_2.total_pieces
    ret_sales_ppo.total_sales_2 = sales_ppo_2.total_sales
    ret_sales_ppo.total_revenue_2 = sales_ppo_2.total_revenue
    ret_sales_ppo.total_product_cost_2 = sales_ppo_2.total_product_cost
    ret_sales_ppo.total_var_cost_2 = sales_ppo_2.total_var_cost
    ret_sales_ppo.total_fixed_cost_2 = sales_ppo_2.total_fixed_cost
    ret_sales_ppo.total_refund_2 = sales_ppo_2.total_refund
    ret_sales_ppo.total_product_dam_cost_2 = sales_ppo_2.total_product_dam_cost
    ret_sales_ppo.profit_per_order_2 = sales_ppo_2.profit_per_order



    ret_sales_ppo.description = "R-1: #{rate_best_of_three.note} @ #{rate_best_of_three.rate.round(1)}| R-2:  #{sales_ppo_2.correction}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  def sales_hour_ppos_for_date from_date, to_date, start_total_secs, end_total_secs, ret_def = 0, to_def = 0
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value

    retail_def = ret_def.to_f if ret_def.to_i > 0
    transfer_def = to_def.to_f if to_def.to_i > 0

    campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", from_date, to_date)
    .where("(start_hr * 60) + (start_min) >= ? AND ((start_hr * 60) + start_min) <= ?", start_total_secs, end_total_secs)
    .where(list_status_id: 10000).order("for_date, start_hr, start_min")

    return if campaign_playlists.blank?

    combined_fixed_cost = campaign_playlists.sum(:cost).to_f

    combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?


   campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new


    rate_best_of_threes = return_rate.retail_best_of_three(playlist.productvariantid, campaign.mediumid)
    rate_best_of_three = rate_best_of_threes.first
    #campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
    # sales_ppo_1 = calculate_campaign_ppo playlist.id, true, false, rate_best_of_three.rate, 65.0, "all"
    #    sales_ppo_2 = calculate_campaign_ppo playlist.id, true, false, 40.00, 65.00,"all"
    sales_ppo_1 = calculate_product_ppo playlist.id, true, false, rate_best_of_three.rate, 65.00, "all", playlist.productvariantid
    #, 0, 0, 0, 0
    sales_ppo_2 = calculate_product_ppo playlist.id, true, false, retail_def, transfer_def, "all", playlist.productvariantid
    #, 0, 0, 0, 0

    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    ret_sales_ppo.for_date = playlist.for_date
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{rate_best_of_three.rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.show = playlist.product_variant.name
    ret_sales_ppo.show_time = playlist.starttime
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    #row 1
    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order
    # row 2
    ret_sales_ppo.total_nos_2 = sales_ppo_2.total_nos
    ret_sales_ppo.total_pieces_2 = sales_ppo_2.total_pieces
    ret_sales_ppo.total_sales_2 = sales_ppo_2.total_sales
    ret_sales_ppo.total_revenue_2 = sales_ppo_2.total_revenue
    ret_sales_ppo.total_product_cost_2 = sales_ppo_2.total_product_cost
    ret_sales_ppo.total_var_cost_2 = sales_ppo_2.total_var_cost
    ret_sales_ppo.total_fixed_cost_2 = sales_ppo_2.total_fixed_cost
    ret_sales_ppo.total_refund_2 = sales_ppo_2.total_refund
    ret_sales_ppo.total_product_dam_cost_2 = sales_ppo_2.total_product_dam_cost
    ret_sales_ppo.profit_per_order_2 = sales_ppo_2.profit_per_order



    ret_sales_ppo.description = "R-1: #{rate_best_of_three.note} @ #{rate_best_of_three.rate.round(1)}| R-2:  #{sales_ppo_2.correction}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  def operator_ppos_for_date from_date, to_date, media_id, ret_def = 0, to_def = 0
    out_sales_ppos = []
    nos = 1

    #retail_def = 49.00
    retail_def = SalesPpoDefault.find_by_name("Retail").value
    #transfer_def = 65.00
    transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value

    retail_def = ret_def.to_f if ret_def.to_i > 0
    transfer_def = to_def.to_f if to_def.to_i > 0

    campaign_playlists = CampaignPlaylist.where("for_date >= ? and for_date <= ?", from_date, to_date)
           .where(list_status_id: 10000)
           .order("for_date, start_hr, start_min")


           combined_fixed_cost = campaign_playlists.sum(:cost).to_f

           combined_fixed_cost = campaign_playlists.first.group_total_cost.to_f if campaign_playlists.first.group_total_cost.present?


    #combined_fixed_cost = campaign_playlists.sum(:cost).to_f

   campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new


    rate_best_of_threes = return_rate.retail_best_of_three(playlist.productvariantid, campaign.mediumid)
    rate_best_of_three = rate_best_of_threes.first
    #campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results
    sales_ppo_1 = operator_ppo playlist.id, true, false, rate_best_of_three.rate, 65.0, "all", media_id
    sales_ppo_2 = operator_ppo playlist.id, true, false, retail_def, transfer_def, "all", media_id
    #    byebug
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.product_variant_id = playlist.productvariantid
    ret_sales_ppo.for_date = playlist.for_date
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{rate_best_of_three.rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R #{retail_def}% | T #{transfer_def}%"
    ret_sales_ppo.show = playlist.product_variant.name
    ret_sales_ppo.show_time = playlist.starttime
    # row 1
    ret_sales_ppo.total_nos_1 = sales_ppo_1.total_nos
    ret_sales_ppo.total_pieces_1 = sales_ppo_1.total_pieces
    ret_sales_ppo.total_sales_1 = sales_ppo_1.total_sales
    ret_sales_ppo.total_revenue_1 = sales_ppo_1.total_revenue
    ret_sales_ppo.total_product_cost_1 = sales_ppo_1.total_product_cost
    ret_sales_ppo.total_var_cost_1 = sales_ppo_1.total_var_cost
    ret_sales_ppo.total_fixed_cost_1 = sales_ppo_1.total_fixed_cost
    ret_sales_ppo.total_refund_1 = sales_ppo_1.total_refund
    ret_sales_ppo.total_product_dam_cost_1 = sales_ppo_1.total_product_dam_cost
    ret_sales_ppo.profit_per_order_1 = sales_ppo_1.profit_per_order
    # row 2
    ret_sales_ppo.total_nos_2 = sales_ppo_2.total_nos
    ret_sales_ppo.total_pieces_2 = sales_ppo_2.total_pieces
    ret_sales_ppo.total_sales_2 = sales_ppo_2.total_sales
    ret_sales_ppo.total_revenue_2 = sales_ppo_2.total_revenue
    ret_sales_ppo.total_product_cost_2 = sales_ppo_2.total_product_cost
    ret_sales_ppo.total_var_cost_2 = sales_ppo_2.total_var_cost
    ret_sales_ppo.total_fixed_cost_2 = sales_ppo_2.total_fixed_cost
    ret_sales_ppo.total_refund_2 = sales_ppo_2.total_refund
    ret_sales_ppo.total_product_dam_cost_2 = sales_ppo_2.total_product_dam_cost
    ret_sales_ppo.profit_per_order_2 = sales_ppo_2.profit_per_order



    ret_sales_ppo.description = "R-1: #{rate_best_of_three.note} @ #{rate_best_of_three.rate.round(1)}| R-2:  #{sales_ppo_2.correction}"
    out_sales_ppos << ret_sales_ppo
           ## save to return the sales ppo
    end
   ## end all tasks above this
   return out_sales_ppos
  end

  def corrected_date_time(for_date, for_hour, for_minute)
    for_hour = for_hour.to_s.rjust(2, '0')
    for_minute = for_minute.to_s.rjust(2, '0')
    for_date = for_date.strftime("%Y-%m-%d")
    #byebug
    #string_date = for_date + " " + for_hour + ":" + for_minute + ":00"
    base_date = DateTime.strptime("#{for_date} #{for_hour}:#{for_minute}:00 + 5:30", "%Y-%m-%d %H:%M:%S")
    #return return_date = DateTime.strptime(string_date, "%Y-%m-%d %H:%M:%S")
    return (base_date - 300.minutes).strftime("%Y-%m-%d %H:%M:%S")
  end

  def show_open_orders(campaign_id)

    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    open_status_ids = [10040, 10006, 10008, 10040, 10041, 10007]

    sales_ppos = SalesPpo.where('order_status_id > 10000').where(campaign_playlist_id: campaign_id) #.pluck(:id, :order_status_id, :order_id)

    order_count = SalesPpo.new
    # attr_accessor :all_orders, :retail_orders, :shipped_orders, :transfer_orders, :open_orders
    order_count.all_orders = sales_ppos.distinct.count('order_id')
    order_count.retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
    order_count.shipped_orders = sales_ppos.where('order_status_id > 10004').distinct.count('order_id')
    order_count.transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')
    order_count.open_orders = sales_ppos.where.not(order_status_id: open_status_ids).distinct.count('order_id')

    return order_count
  end

  private
  def all_cancelled_orders
    cancelled_status_ids = [10040, 10006, 10008]
    #10040 => tranfer order cancelled
    #10006 => CFO cancelled at origin orders
    #10008 => Returned Order (post shipping) / unclaimed orders
    #session[:cancelled_status_id] = @cancelled_status_id
  end

  # if product_variant_id.present?
  #   sales_ppos = sales_ppos.where(product_variant_id: product_variant_id)
  # end
  def remove_from_sales_ppo order_id
    order_master = OrderMaster.find(order_id)

    order_lines = OrderLine.where(orderid: order_id)
    order_lines.each do |ordln|
    #add or update ppo details
      if SalesPpo.where(:order_line_id=> ordln.id).present?
        sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first
        sale_ppo.destroy
        puts "Destroyed for order id #{order_master.id}" #.colorize(:black).colorize(:background => :red)
      end
    end
  end

  def calculate_campaign_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results

    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?

    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    campaign = Campaign.find(campaign_playlist.campaignid)
    total_fixed_cost = campaign_playlist.cost.to_i
    #total_fixed_cost = campaign_playlists.sum(:cost).to_f

    total_fixed_cost = campaign_playlist.group_total_cost.to_f if campaign_playlist.group_total_cost.present?

    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]

     sales_ppos = SalesPpo.where('order_status_id > 10000')
          .where(campaign_playlist_id: campaign_playlist_id)
          .order("start_time")

          sales_ppo = SalesPpo.new
          sales_ppo.product_variant_id = campaign_playlist.productvariantid
          sales_ppo.for_date = campaign_playlist.for_date
          sales_ppo.prod = campaign_playlist.product_variant.extproductcode

          sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).present?


           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end

          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')

          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)

          if transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
             transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
             transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)
             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2)
             transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)

             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2)
             reverse_correction = (1.0 - transfer_correction).to_f
             transfer_total_var_on_order_cost = (transfer_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2)

             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2)

             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0

             transfer_order_total_revenue = (transfer_order_total_revenue).round(2)

             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

             if transfer_orders > 0
              transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
              # sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
             else
              transfer_total_fixed_cost = total_fixed_cost
             end

             ### dont correct these values they are already corrected from above
             transfer_total_product_dam_cost = (transfer_total_product_cost * 0.10).round(2)
             transfer_total_refund = (transfer_total_sales * 0.02).round(2)

             transfer_total_cost_per_order = (transfer_total_product_cost + transfer_total_fixed_cost + transfer_total_var_cost + (transfer_total_var_on_order_cost || 0) + transfer_total_refund + transfer_total_product_dam_cost + (transfer_total_promo_cost || 0)).round(2)

             transfer_total_cost_per_order = (transfer_total_cost_per_order - (transfer_rev_shipping_cost || 0)).round(2)

             #revise total nos if it is less than 1
             transfer_cor_total_nos = 1
             if transfer_total_nos.present? && transfer_total_nos > 1
               transfer_cor_total_nos = transfer_total_nos
             end

             transfer_cost_per_order = (transfer_total_cost_per_order.to_f / transfer_cor_total_nos).round(2)
             transfer_total_profit = (transfer_total_revenue - transfer_total_cost_per_order).round(2)
             transfer_profit_per_order  = (transfer_total_profit.to_f  / transfer_cor_total_nos).round(2)
          end

          if retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            retail_correction = retail_correction ||= 1.0

            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)
            retail_total_pieces = (retail_sales_ppos.sum(:pieces)  * retail_correction).round(2)
            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2)
            retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2)

            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2)

            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2)

            #.where.not(order_status_id: tranfer_order_ids)
            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2)

            reverse_correction = (1.0 - retail_correction).to_f
            retail_total_var_on_order_cost = (retail_sales_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)

            if retail_orders > 0
              retail_total_fixed_cost = ((total_fixed_cost.to_f / all_orders.to_f) * retail_orders).round(2)
              #sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
            else
               retail_total_fixed_cost = total_fixed_cost
            end

            ### dont correct these values they are already corrected from above
            retail_total_product_dam_cost = (retail_total_product_cost * 0.10).round(2)
            retail_total_refund = (retail_total_sales * 0.02).round(2)

            retail_total_cost_per_order = ((retail_total_product_cost || 0) + (retail_total_fixed_cost || 0 ) + (retail_total_var_cost || 0 ) + (retail_total_var_on_order_cost || 0) + (retail_total_refund || 0 ) + (retail_total_product_dam_cost || 0) + (retail_shipping_cost || 0) + (retail_total_promo_cost || 0)).round(2)

            #revise total nos if it is less than 1
             retail_cor_total_nos = 1
            if retail_total_nos.present? && retail_total_nos > 1
              retail_cor_total_nos = retail_total_nos
            end

            retail_cost_per_order = (retail_total_cost_per_order.to_f / retail_cor_total_nos).round(2)
            retail_total_profit = (retail_total_revenue - retail_total_cost_per_order).round(2)
            retail_profit_per_order  = (retail_total_profit.to_f  / retail_cor_total_nos).round(2)

          end


           if results=="all"
             retail_correction = retail_correction ||= 1.0
             transfer_correction = transfer_correction ||= 1.0
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = ((retail_total_sales || 0) + (transfer_total_sales || 0)).round(2)
             sales_ppo.total_revenue = ((retail_total_revenue || 0) + (transfer_total_revenue || 0)).round(2)

             sales_ppo.total_nos = ((retail_total_nos || 0) + (transfer_total_nos || 0)).round(2)
             sales_ppo.total_pieces = ((retail_total_pieces || 0) + (transfer_total_pieces || 0)).round(2)
             sales_ppo.total_product_cost = ((retail_total_product_cost || 0) + (transfer_total_product_cost || 0)).round(2)
             sales_ppo.total_product_dam_cost = ((retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)).round(2)

             sales_ppo.total_refund = ((retail_total_refund || 0) + (transfer_total_refund || 0)).round(2)
             sales_ppo.total_promo_cost = ((retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0)).round(2)
             sales_ppo.total_var_cost = ((retail_total_var_cost || 0) + (transfer_total_var_cost || 0)).round(2)
             sales_ppo.total_var_on_order_cost = ((retail_total_var_on_order_cost || 0) + (transfer_total_var_on_order_cost || 0)).round(2)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0) + (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = ((retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)).round(2)
             sales_ppo.correction = ((((retail_correction.to_f * 100 )|| 0) + ((transfer_correction.to_f * 100) || 0))/ 2 ).round(2)

             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name

             sales_ppo.total_cost_per_order = ((retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )).round(2)

             sales_ppo.cost_per_order = ((retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )).round(2)
             sales_ppo.total_profit = ((retail_total_profit || 0) + (transfer_total_profit || 0)).round(2)
             sales_ppo.cor_total_nos = ((retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)).round(2)
             # sales_ppo.profit_per_order = ((retail_profit_per_order || 0) + (transfer_profit_per_order || 0)).round(2)


             if sales_ppo.cor_total_nos.present? && sales_ppo.cor_total_nos > 0
               sales_ppo.profit_per_order = ((sales_ppo.total_profit || 0) / sales_ppo.cor_total_nos).round(2)
             else
                sales_ppo.cor_total_nos = 1
             end

           elsif results=="to"

             sales_ppo.total_sales = (transfer_total_sales || 0)
             sales_ppo.total_revenue = (transfer_total_revenue || 0)

             sales_ppo.total_nos = (transfer_total_nos || 0)
             sales_ppo.total_pieces = (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (transfer_total_product_dam_cost || 0)

             sales_ppo.total_refund = (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (transfer_total_promo_cost || 0)
             sales_ppo.total_var_cost = (transfer_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (transfer_total_var_on_order_cost || 0)
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0)

             sales_ppo.shipping_cost = (transfer_rev_shipping_cost || 0)
             sales_ppo.correction =  (transfer_correction * 100) || 1.0 if transfer_correction.present?

             sales_ppo.postage_name = " less postage added" #postage_name

             sales_ppo.total_cost_per_order = (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (transfer_cor_total_nos || 0)

           elsif results=="retail"
             sales_ppo.total_sales = (retail_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0)

             sales_ppo.total_refund = (retail_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0)
             sales_ppo.total_var_cost = (retail_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (retail_total_var_on_order_cost || 0)
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = (retail_shipping_cost || 0)
             sales_ppo.correction = (retail_correction * 100.0) || 1.0 if retail_correction.present?

             sales_ppo.postage_name = " add if not taking 100%" #postage_name

             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0)
           end

      return sales_ppo
  end

  def calculate_product_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results, product_variant_id
    #, sim_product_cost = 0, sim_retail_sales_pieces = 0, sim_to_sales_pieces = 0, sim_product_total = 0

    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?

    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    campaign = Campaign.find(campaign_playlist.campaignid)
    total_fixed_cost = campaign_playlist.cost.to_i
    #total_fixed_cost = campaign_playlists.sum(:cost).to_f

    total_fixed_cost = campaign_playlist.group_total_cost.to_f if campaign_playlist.group_total_cost.present?

    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    #get additional produvt variant ids
    product_variant_ids = []
    product_variant_ids << product_variant_id
    if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(campaign_playlist_id).present?)
      product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id: campaign_playlist_id).pluck(:product_variant_id)
    end
     sales_ppos = SalesPpo.where('order_status_id > 10000')
          .where(campaign_playlist_id: campaign_playlist_id,
          product_variant_id: product_variant_ids)
          .order("start_time")

          sales_ppo = SalesPpo.new
          sales_ppo.product_variant_id = product_variant_id
          sales_ppo.for_date = campaign_playlist.for_date
          sales_ppo.prod = campaign_playlist.product_variant.extproductcode

          sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).present?

           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end

          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')

          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)

          if transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
               transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)

              transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
              transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
              transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)


             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2)

             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2)
             reverse_correction = (1.0 - transfer_correction).to_f

             transfer_total_var_on_order_cost = (transfer_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2)

             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2)

             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0

             transfer_order_total_revenue = (transfer_order_total_revenue).round(2)

             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

             if transfer_orders > 0
              transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
              # sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
             else
              transfer_total_fixed_cost = total_fixed_cost
             end

             ### dont correct these values they are already corrected from above
             transfer_total_product_dam_cost = (transfer_total_product_cost * 0.10).round(2)
             transfer_total_refund = (transfer_total_sales * 0.02).round(2)

             transfer_total_cost_per_order = (transfer_total_product_cost + transfer_total_fixed_cost + transfer_total_var_cost + (transfer_total_var_on_order_cost || 0) + transfer_total_refund + transfer_total_product_dam_cost + (transfer_total_promo_cost || 0)).round(2)

             transfer_total_cost_per_order = (transfer_total_cost_per_order - (transfer_rev_shipping_cost || 0)).round(2)

             #revise total nos if it is less than 1
             transfer_cor_total_nos = 1
             if transfer_total_nos.present? && transfer_total_nos > 1
               transfer_cor_total_nos = transfer_total_nos
             end

             transfer_cost_per_order = (transfer_total_cost_per_order.to_f / transfer_cor_total_nos).round(2)
             transfer_total_profit = (transfer_total_revenue - transfer_total_cost_per_order).round(2)
             transfer_profit_per_order  = (transfer_total_profit.to_f  / transfer_cor_total_nos).round(2)
          end

          if retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            retail_correction = retail_correction ||= 1.0

            retail_total_pieces = (retail_sales_ppos.sum(:pieces)  * retail_correction).round(2)
            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)

            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2)

            retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2)

            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_total_var_on_order_cost = (retail_sales_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2)

            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2)

            #.where.not(order_status_id: tranfer_order_ids)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)

            if retail_orders > 0
              retail_total_fixed_cost = ((total_fixed_cost.to_f / all_orders.to_f) * retail_orders).round(2)
              #sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
            else
               retail_total_fixed_cost = total_fixed_cost
            end

            ### dont correct these values they are already corrected from above
            retail_total_product_dam_cost = (retail_total_product_cost * 0.10).round(2)
            retail_total_refund = (retail_total_sales * 0.02).round(2)

            retail_total_cost_per_order = ((retail_total_product_cost || 0) + (retail_total_fixed_cost || 0 ) + (retail_total_var_cost || 0 ) + (retail_total_var_on_order_cost || 0) + (retail_total_refund || 0 ) + (retail_total_product_dam_cost || 0) + (retail_shipping_cost || 0) + (retail_total_promo_cost || 0)).round(2)

            #revise total nos if it is less than 1
             retail_cor_total_nos = 1
            if retail_total_nos.present? && retail_total_nos > 1
              retail_cor_total_nos = retail_total_nos
            end

            retail_cost_per_order = (retail_total_cost_per_order.to_f / retail_cor_total_nos).round(2)
            retail_total_profit = (retail_total_revenue - retail_total_cost_per_order).round(2)
            retail_profit_per_order  = (retail_total_profit.to_f  / retail_cor_total_nos).round(2)

          end


           if results=="all"
             retail_correction = retail_correction ||= 1.0
             transfer_correction = transfer_correction ||= 1.0
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = ((retail_total_sales || 0) + (transfer_total_sales || 0)).round(2)
             sales_ppo.total_revenue = ((retail_total_revenue || 0) + (transfer_total_revenue || 0)).round(2)

             sales_ppo.total_nos = ((retail_total_nos || 0) + (transfer_total_nos || 0)).round(2)
             sales_ppo.total_pieces = ((retail_total_pieces || 0) + (transfer_total_pieces || 0)).round(2)
             sales_ppo.total_product_cost = ((retail_total_product_cost || 0) + (transfer_total_product_cost || 0)).round(2)
             sales_ppo.total_product_dam_cost = ((retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)).round(2)

             sales_ppo.total_refund = ((retail_total_refund || 0) + (transfer_total_refund || 0)).round(2)
             sales_ppo.total_promo_cost = ((retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0)).round(2)
             sales_ppo.total_var_cost = ((retail_total_var_cost || 0) + (transfer_total_var_cost || 0)).round(2)

             sales_ppo.total_var_on_order_cost = ((retail_total_var_on_order_cost || 0) + (transfer_total_var_on_order_cost || 0)).round(2)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0) + (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = ((retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)).round(2)
             sales_ppo.correction = ((((retail_correction.to_f * 100 )|| 0) + ((transfer_correction.to_f * 100) || 0))/ 2 ).round(2)

             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name

             sales_ppo.total_cost_per_order = ((retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )).round(2)

             sales_ppo.cost_per_order = ((retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )).round(2)
             sales_ppo.total_profit = ((retail_total_profit || 0) + (transfer_total_profit || 0)).round(2)
             sales_ppo.cor_total_nos = ((retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)).round(2)
             # sales_ppo.profit_per_order = ((retail_profit_per_order || 0) + (transfer_profit_per_order || 0)).round(2)

             if sales_ppo.cor_total_nos.present? && sales_ppo.cor_total_nos > 0
               sales_ppo.profit_per_order = ((sales_ppo.total_profit || 0) / sales_ppo.cor_total_nos).round(2)
             else
                sales_ppo.cor_total_nos = 1
             end

           elsif results=="to"

             sales_ppo.total_sales = (transfer_total_sales || 0)
             sales_ppo.total_revenue = (transfer_total_revenue || 0)

             sales_ppo.total_nos = (transfer_total_nos || 0)
             sales_ppo.total_pieces = (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (transfer_total_product_dam_cost || 0)

             sales_ppo.total_refund = (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (transfer_total_promo_cost || 0)
             sales_ppo.total_var_cost = (transfer_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (transfer_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0)

             sales_ppo.shipping_cost = (transfer_rev_shipping_cost || 0)
             sales_ppo.correction =  (transfer_correction * 100) || 1.0 if transfer_correction.present?

             sales_ppo.postage_name = " less postage added" #postage_name

             sales_ppo.total_cost_per_order = (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (transfer_cor_total_nos || 0)

           elsif results=="retail"

             sales_ppo.total_sales = (retail_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0)

             sales_ppo.total_refund = (retail_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0)
             sales_ppo.total_var_cost = (retail_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (retail_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = (retail_shipping_cost || 0)
             sales_ppo.correction = (retail_correction * 100.0) || 1.0 if retail_correction.present?

             sales_ppo.postage_name = " add if not taking 100%" #postage_name

             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0)
           end

      return sales_ppo
  end

  def sim_calculate_product_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results, product_variant_id, sim_product_cost = 0, sim_retail_sales_pieces = 0, sim_to_sales_pieces = 0, sim_product_total = 0

    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?

    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    campaign = Campaign.find(campaign_playlist.campaignid)
    total_fixed_cost = campaign_playlist.cost.to_i
    #total_fixed_cost = campaign_playlists.sum(:cost).to_f

    total_fixed_cost = campaign_playlist.group_total_cost.to_f if campaign_playlist.group_total_cost.present?

    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    #get additional produvt variant ids
    product_variant_ids = []
    product_variant_ids << product_variant_id
    if (CampaignPlaylistToProduct.find_by_campaign_playlist_id(campaign_playlist_id).present?)
      product_variant_ids << CampaignPlaylistToProduct.where(campaign_playlist_id: campaign_playlist_id).pluck(:product_variant_id)
    end
     sales_ppos = SalesPpo.where('order_status_id > 10000')
          .where(campaign_playlist_id: campaign_playlist_id,
          product_variant_id: product_variant_ids)
          .order("start_time")

          sales_ppo = SalesPpo.new
          sales_ppo.product_variant_id = product_variant_id
          sales_ppo.for_date = campaign_playlist.for_date
          sales_ppo.prod = campaign_playlist.product_variant.extproductcode

          sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).present?

           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end
          all_orders =  sim_to_sales_pieces + sim_retail_sales_pieces
          #all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sim_retail_sales_pieces #sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sim_to_sales_pieces #sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')

          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)

          if transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
               #transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)
               transfer_total_nos = sim_to_sales_pieces
            #  if sim_to_sales_pieces.to_i > 0
               transfer_total_pieces = sim_to_sales_pieces.to_i
               transfer_total_sales = sim_to_sales_pieces.to_i * sim_product_total
               transfer_total_product_cost = sim_product_cost
            #  else
            #   transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
            #   transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
            #   transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)
            #  end

             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2)

             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2)
             reverse_correction = (1.0 - transfer_correction).to_f
             transfer_total_var_on_order_cost = (transfer_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2)

             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2)

             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0

             transfer_order_total_revenue = (transfer_order_total_revenue).round(2)

             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

             if transfer_orders > 0
              transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
              # sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
             else
              transfer_total_fixed_cost = total_fixed_cost
             end

             ### dont correct these values they are already corrected from above
             transfer_total_product_dam_cost = (transfer_total_product_cost * 0.10).round(2)
             transfer_total_refund = (transfer_total_sales * 0.02).round(2)

             transfer_total_cost_per_order = (transfer_total_product_cost + transfer_total_fixed_cost + transfer_total_var_cost + (transfer_total_var_on_order_cost || 0) + transfer_total_refund + transfer_total_product_dam_cost + (transfer_total_promo_cost || 0)).round(2)

             transfer_total_cost_per_order = (transfer_total_cost_per_order - (transfer_rev_shipping_cost || 0)).round(2)

             #revise total nos if it is less than 1
             transfer_cor_total_nos = 1
             if transfer_total_nos.present? && transfer_total_nos > 1
               transfer_cor_total_nos = transfer_total_nos
             end

             transfer_cost_per_order = (transfer_total_cost_per_order.to_f / transfer_cor_total_nos).round(2)
             transfer_total_profit = (transfer_total_revenue - transfer_total_cost_per_order).round(2)
             transfer_profit_per_order  = (transfer_total_profit.to_f  / transfer_cor_total_nos).round(2)
          end

          if retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            retail_correction = retail_correction ||= 1.0

            if sim_retail_sales_pieces.to_i > 0
              transfer_total_pieces = (sim_retail_sales_pieces.to_f * retail_correction).round(2)
              transfer_total_sales = (sim_retail_sales_pieces.to_f * sim_product_total.to_f * retail_correction).round(2)
              transfer_total_product_cost = (sim_product_cost.to_f * retail_correction).round(2)
            else
             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
             transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)
            end

            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)

            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2)

            if product_cost.present?
              retail_total_product_cost = ((retail_total_pieces * product_cost) * retail_correction).round(2)
            else
              retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2)
            end


            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_total_var_on_order_cost = (retail_sales_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2)

            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2)

            #.where.not(order_status_id: tranfer_order_ids)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)

            if retail_orders > 0
              retail_total_fixed_cost = ((total_fixed_cost.to_f / all_orders.to_f) * retail_orders).round(2)
              #sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
            else
               retail_total_fixed_cost = total_fixed_cost
            end

            ### dont correct these values they are already corrected from above
            retail_total_product_dam_cost = (retail_total_product_cost * 0.10).round(2)
            retail_total_refund = (retail_total_sales * 0.02).round(2)

            retail_total_cost_per_order = ((retail_total_product_cost || 0) + (retail_total_fixed_cost || 0 ) + (retail_total_var_cost || 0 ) + (retail_total_var_on_order_cost || 0) + (retail_total_refund || 0 ) + (retail_total_product_dam_cost || 0) + (retail_shipping_cost || 0) + (retail_total_promo_cost || 0)).round(2)

            #revise total nos if it is less than 1
             retail_cor_total_nos = 1
            if retail_total_nos.present? && retail_total_nos > 1
              retail_cor_total_nos = retail_total_nos
            end

            retail_cost_per_order = (retail_total_cost_per_order.to_f / retail_cor_total_nos).round(2)
            retail_total_profit = (retail_total_revenue - retail_total_cost_per_order).round(2)
            retail_profit_per_order  = (retail_total_profit.to_f  / retail_cor_total_nos).round(2)

          end


           if results=="all"
             retail_correction = retail_correction ||= 1.0
             transfer_correction = transfer_correction ||= 1.0
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = ((retail_total_sales || 0) + (transfer_total_sales || 0)).round(2)
             sales_ppo.total_revenue = ((retail_total_revenue || 0) + (transfer_total_revenue || 0)).round(2)

             sales_ppo.total_nos = ((retail_total_nos || 0) + (transfer_total_nos || 0)).round(2)
             sales_ppo.total_pieces = ((retail_total_pieces || 0) + (transfer_total_pieces || 0)).round(2)
             sales_ppo.total_product_cost = ((retail_total_product_cost || 0) + (transfer_total_product_cost || 0)).round(2)
             sales_ppo.total_product_dam_cost = ((retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)).round(2)

             sales_ppo.total_refund = ((retail_total_refund || 0) + (transfer_total_refund || 0)).round(2)
             sales_ppo.total_promo_cost = ((retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0)).round(2)
             sales_ppo.total_var_cost = ((retail_total_var_cost || 0) + (transfer_total_var_cost || 0)).round(2)

             sales_ppo.total_var_on_order_cost = ((retail_total_var_on_order_cost || 0) + (transfer_total_var_on_order_cost || 0)).round(2)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0) + (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = ((retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)).round(2)
             sales_ppo.correction = ((((retail_correction.to_f * 100 )|| 0) + ((transfer_correction.to_f * 100) || 0))/ 2 ).round(2)

             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name

             sales_ppo.total_cost_per_order = ((retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )).round(2)

             sales_ppo.cost_per_order = ((retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )).round(2)
             sales_ppo.total_profit = ((retail_total_profit || 0) + (transfer_total_profit || 0)).round(2)
             sales_ppo.cor_total_nos = ((retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)).round(2)
             # sales_ppo.profit_per_order = ((retail_profit_per_order || 0) + (transfer_profit_per_order || 0)).round(2)

             if sales_ppo.cor_total_nos.present? && sales_ppo.cor_total_nos > 0
               sales_ppo.profit_per_order = ((sales_ppo.total_profit || 0) / sales_ppo.cor_total_nos).round(2)
             else
                sales_ppo.cor_total_nos = 1
             end

           elsif results=="to"

             sales_ppo.total_sales = (transfer_total_sales || 0)
             sales_ppo.total_revenue = (transfer_total_revenue || 0)

             sales_ppo.total_nos = (transfer_total_nos || 0)
             sales_ppo.total_pieces = (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (transfer_total_product_dam_cost || 0)

             sales_ppo.total_refund = (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (transfer_total_promo_cost || 0)
             sales_ppo.total_var_cost = (transfer_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (transfer_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0)

             sales_ppo.shipping_cost = (transfer_rev_shipping_cost || 0)
             sales_ppo.correction =  (transfer_correction * 100) || 1.0 if transfer_correction.present?

             sales_ppo.postage_name = " less postage added" #postage_name

             sales_ppo.total_cost_per_order = (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (transfer_cor_total_nos || 0)

           elsif results=="retail"

             sales_ppo.total_sales = (retail_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0)

             sales_ppo.total_refund = (retail_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0)
             sales_ppo.total_var_cost = (retail_total_var_cost || 0)
             sales_ppo.retail_var_on_order_cost = (retail_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = (retail_shipping_cost || 0)
             sales_ppo.correction = (retail_correction * 100.0) || 1.0 if retail_correction.present?

             sales_ppo.postage_name = " add if not taking 100%" #postage_name

             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0)
           end

      return sales_ppo
  end


  def daily_campaign_ppo for_date, show_all, show_shipped, ret_correct, to_correct, results

    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?

    campaign_playlists = CampaignPlaylist.where("TRUNC(for_date) = ?", for_date)
           #.where(list_status_id: 10000)

    # campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    #     campaign = Campaign.find(campaign_playlist.campaignid)
    #total_fixed_cost = campaign_playlists.first.cost.to_i || 0 if campaign_playlists.first.cost.present?
    total_fixed_cost = campaign_playlists.sum(:cost).to_f

    # total_fixed_cost = campaign_playlists.sum(:group_total_cost).to_f if campaign_playlists.first.group_total_cost.present?


    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]

     sales_ppos = SalesPpo.where('order_status_id > 10000')
          .where("TRUNC(start_time) = ?", for_date)

          sales_ppo = SalesPpo.new
          # sales_ppo.product_variant_id = campaign_playlist.productvariantid
          # sales_ppo.for_date = campaign_playlist.for_date
          #sales_ppo.prod = campaign_playlist.product_variant.extproductcode

          #sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = sales_ppos.sum(:product_cost).to_i

           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end

          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')

          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)

          if transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
             transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
             transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)
             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2)
             transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)
             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2)

             reverse_correction = (1.0 - transfer_correction).to_f
             transfer_total_var_on_order_cost = (transfer_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)


             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2)

             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2)

             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0

             transfer_order_total_revenue = (transfer_order_total_revenue).round(2)

             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

             if transfer_orders > 0
              transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
              # sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
             else
              transfer_total_fixed_cost = total_fixed_cost
             end

             ### dont correct these values they are already corrected from above
             transfer_total_product_dam_cost = (transfer_total_product_cost * 0.10).round(2)
             transfer_total_refund = (transfer_total_sales * 0.02).round(2)

             transfer_total_cost_per_order = ((transfer_total_product_cost || 0)
              + (transfer_total_fixed_cost || 0) + (transfer_total_var_cost || 0) + (transfer_total_var_on_order_cost || 0) + (transfer_total_refund || 0) + (transfer_total_product_dam_cost || 0 ) + (transfer_total_promo_cost || 0)).round(2)

             transfer_total_cost_per_order = (transfer_total_cost_per_order - (transfer_rev_shipping_cost || 0)).round(2)

             #revise total nos if it is less than 1
             transfer_cor_total_nos = 1
             if transfer_total_nos.present? && transfer_total_nos > 1
               transfer_cor_total_nos = transfer_total_nos
             end

             transfer_cost_per_order = (transfer_total_cost_per_order.to_f / transfer_cor_total_nos).round(2)
             transfer_total_profit = (transfer_total_revenue - transfer_total_cost_per_order).round(2)
             transfer_profit_per_order  = (transfer_total_profit.to_f  / transfer_cor_total_nos).round(2)
          end

          if retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            retail_correction = retail_correction ||= 1.0

            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)
            retail_total_pieces = (retail_sales_ppos.sum(:pieces)  * retail_correction).round(2)
            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2)
            retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2)
            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2)
            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2)

            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2)

            reverse_correction = (1.0 - retail_correction).to_f
            retail_total_var_on_order_cost = (retail_sales_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

            #.where.not(order_status_id: tranfer_order_ids)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)

            if retail_orders > 0
              retail_total_fixed_cost = ((total_fixed_cost.to_f / all_orders.to_f) * retail_orders).round(2)
              #sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
            else
               retail_total_fixed_cost = total_fixed_cost
            end

            ### dont correct these values they are already corrected from above
            retail_total_product_dam_cost = (retail_total_product_cost * 0.10).round(2)
            retail_total_refund = (retail_total_sales * 0.02).round(2)

            retail_total_cost_per_order = ((retail_total_product_cost || 0) + (retail_total_fixed_cost || 0 ) + (retail_total_var_cost || 0 ) + (retail_total_var_on_order_cost || 0) + (retail_total_refund || 0 ) + (retail_total_product_dam_cost || 0) + (retail_shipping_cost || 0) + (retail_total_promo_cost || 0)).round(2)

            #revise total nos if it is less than 1
             retail_cor_total_nos = 1
            if retail_total_nos.present? && retail_total_nos > 1
              retail_cor_total_nos = retail_total_nos
            end

            retail_cost_per_order = (retail_total_cost_per_order.to_f / retail_cor_total_nos).round(2)
            retail_total_profit = (retail_total_revenue - retail_total_cost_per_order).round(2)
            retail_profit_per_order  = (retail_total_profit.to_f  / retail_cor_total_nos).round(2)

          end


           if results=="all"
             retail_correction = retail_correction ||= 1.0
             transfer_correction = transfer_correction ||= 1.0
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = ((retail_total_sales || 0) + (transfer_total_sales || 0)).round(2)
             sales_ppo.total_revenue = ((retail_total_revenue || 0) + (transfer_total_revenue || 0)).round(2)

             sales_ppo.total_nos = ((retail_total_nos || 0) + (transfer_total_nos || 0)).round(2)
             sales_ppo.total_pieces = ((retail_total_pieces || 0) + (transfer_total_pieces || 0)).round(2)
             sales_ppo.total_product_cost = ((retail_total_product_cost || 0) + (transfer_total_product_cost || 0)).round(2)
             sales_ppo.total_product_dam_cost = ((retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)).round(2)

             sales_ppo.total_refund = ((retail_total_refund || 0) + (transfer_total_refund || 0)).round(2)
             sales_ppo.total_promo_cost = ((retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0)).round(2)
             sales_ppo.total_var_cost = ((retail_total_var_cost || 0) + (transfer_total_var_cost || 0)).round(2)
             sales_ppo.total_var_on_order_cost = ((retail_total_var_on_order_cost || 0) + (transfer_total_var_on_order_cost || 0)).round(2)
             #retail_total_var_on_order_cost
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0) + (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = ((retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)).round(2)
             sales_ppo.correction = ((((retail_correction.to_f * 100 )|| 0) + ((transfer_correction.to_f * 100) || 0))/ 2 ).round(2)

             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name

             sales_ppo.total_cost_per_order = ((retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )).round(2)

             sales_ppo.cost_per_order = ((retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )).round(2)
             sales_ppo.total_profit = ((retail_total_profit || 0) + (transfer_total_profit || 0)).round(2)
             sales_ppo.cor_total_nos = ((retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)).round(2)
             # sales_ppo.profit_per_order = ((retail_profit_per_order || 0) + (transfer_profit_per_order || 0)).round(2)

             if sales_ppo.cor_total_nos.present? && sales_ppo.cor_total_nos > 0
               sales_ppo.profit_per_order = ((sales_ppo.total_profit || 0) / sales_ppo.cor_total_nos).round(2)
             else
                sales_ppo.cor_total_nos = 1
             end

           elsif results=="to"

             sales_ppo.total_sales = (transfer_total_sales || 0)
             sales_ppo.total_revenue = (transfer_total_revenue || 0)

             sales_ppo.total_nos = (transfer_total_nos || 0)
             sales_ppo.total_pieces = (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (transfer_total_product_dam_cost || 0)

             sales_ppo.total_refund = (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (transfer_total_promo_cost || 0)
             sales_ppo.total_var_cost = (transfer_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (transfer_total_var_on_order_cost || 0)
             #retail_total_var_on_order_cost
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0)

             sales_ppo.shipping_cost = (transfer_rev_shipping_cost || 0)
             sales_ppo.correction =  (transfer_correction * 100) || 1.0 if transfer_correction.present?

             sales_ppo.postage_name = " less postage added" #postage_name

             sales_ppo.total_cost_per_order = (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (transfer_cor_total_nos || 0)

           elsif results=="retail"
             sales_ppo.total_sales = (retail_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0)

             sales_ppo.total_refund = (retail_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0)
             sales_ppo.total_var_cost = (retail_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (retail_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = (retail_shipping_cost || 0)
             sales_ppo.correction = (retail_correction * 100.0) || 1.0 if retail_correction.present?

             sales_ppo.postage_name = " add if not taking 100%" #postage_name

             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0)
           end

      return sales_ppo
  end

  def operator_ppo campaign_playlist_id, show_all, show_shipped, ret_correct, to_correct, results, media_id

    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?

    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    campaign = Campaign.find(campaign_playlist.campaignid)
    total_fixed_cost = campaign_playlist.cost.to_i
    #total_fixed_cost = campaign_playlists.sum(:cost).to_f

    total_fixed_cost = campaign_playlist.group_total_cost.to_f if campaign_playlist.group_total_cost.present?

    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]

     sales_ppos = SalesPpo.where('order_status_id > 10000')
          .where(campaign_playlist_id: campaign_playlist_id)
          .where(media_id: media_id)
          .order("start_time")

          sales_ppo = SalesPpo.new
          sales_ppo.product_variant_id = campaign_playlist.productvariantid
          sales_ppo.for_date = campaign_playlist.for_date
          sales_ppo.prod = campaign_playlist.product_variant.extproductcode

          sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).cost || 0 if ProductCostMaster.find_by_prod(campaign_playlist.product_variant.extproductcode).present?

           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end

          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')

          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)

          if transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
             transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
             transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)
             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2)
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2)
             transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2)
             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2)

             reverse_correction = (1.0 - retail_correction).to_f
             transfer_total_var_on_order_cost = (transfer_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2)

             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2)

             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0

             transfer_order_total_revenue = (transfer_order_total_revenue).round(2)

             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

             if transfer_orders > 0
              transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
              # sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
             else
              transfer_total_fixed_cost = total_fixed_cost
             end

             ### dont correct these values they are already corrected from above
             transfer_total_product_dam_cost = (transfer_total_product_cost * 0.10).round(2)
             transfer_total_refund = (transfer_total_sales * 0.02).round(2)

             transfer_total_cost_per_order = (transfer_total_product_cost + transfer_total_fixed_cost + transfer_total_var_cost + transfer_total_refund + transfer_total_product_dam_cost + (transfer_total_promo_cost || 0)).round(2)

             transfer_total_cost_per_order = (transfer_total_cost_per_order - (transfer_rev_shipping_cost || 0)).round(2)

             #revise total nos if it is less than 1
             transfer_cor_total_nos = 1
             if transfer_total_nos.present? && transfer_total_nos > 1
               transfer_cor_total_nos = transfer_total_nos
             end

             transfer_cost_per_order = (transfer_total_cost_per_order.to_f / transfer_cor_total_nos).round(2)
             transfer_total_profit = (transfer_total_revenue - transfer_total_cost_per_order).round(2)
             transfer_profit_per_order  = (transfer_total_profit.to_f  / transfer_cor_total_nos).round(2)
          end

          if retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            retail_correction = retail_correction ||= 1.0

            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)
            retail_total_pieces = (retail_sales_ppos.sum(:pieces)  * retail_correction).round(2)
            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2)
            retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2)
            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2)

            reverse_correction = (1.0 - retail_correction).to_f
            retail_total_var_on_order_cost = (retail_sales_ppos.sum(:commission_on_order) * (1.0 + reverse_correction)).round(2)

            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2)

            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2)

            #.where.not(order_status_id: tranfer_order_ids)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)

            if retail_orders > 0
              retail_total_fixed_cost = ((total_fixed_cost.to_f / all_orders.to_f) * retail_orders).round(2)
              #sales_ppo.total_fixed_cost = ((retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)).round(2)
            else
               retail_total_fixed_cost = total_fixed_cost
            end

            ### dont correct these values they are already corrected from above
            retail_total_product_dam_cost = (retail_total_product_cost * 0.10).round(2)
            retail_total_refund = (retail_total_sales * 0.02).round(2)

            retail_total_cost_per_order = ((retail_total_product_cost || 0) + (retail_total_fixed_cost || 0 ) + (retail_total_var_cost || 0 ) + (retail_total_refund || 0 ) + (retail_total_product_dam_cost || 0) + (retail_shipping_cost || 0) + (retail_total_promo_cost || 0)).round(2)

            #revise total nos if it is less than 1
             retail_cor_total_nos = 1
            if retail_total_nos.present? && retail_total_nos > 1
              retail_cor_total_nos = retail_total_nos
            end

            retail_cost_per_order = (retail_total_cost_per_order.to_f / retail_cor_total_nos).round(2)
            retail_total_profit = (retail_total_revenue - retail_total_cost_per_order).round(2)
            retail_profit_per_order  = (retail_total_profit.to_f  / retail_cor_total_nos).round(2)

          end


           if results=="all"
             retail_correction = retail_correction ||= 1.0
             transfer_correction = transfer_correction ||= 1.0
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = ((retail_total_sales || 0) + (transfer_total_sales || 0)).round(2)
             sales_ppo.total_revenue = ((retail_total_revenue || 0) + (transfer_total_revenue || 0)).round(2)

             sales_ppo.total_nos = ((retail_total_nos || 0) + (transfer_total_nos || 0)).round(2)
             sales_ppo.total_pieces = ((retail_total_pieces || 0) + (transfer_total_pieces || 0)).round(2)
             sales_ppo.total_product_cost = ((retail_total_product_cost || 0) + (transfer_total_product_cost || 0)).round(2)
             sales_ppo.total_product_dam_cost = ((retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)).round(2)

             sales_ppo.total_refund = ((retail_total_refund || 0) + (transfer_total_refund || 0)).round(2)
             sales_ppo.total_promo_cost = ((retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0)).round(2)
             sales_ppo.total_var_cost = ((retail_total_var_cost || 0) + (transfer_total_var_cost || 0)).round(2)
             sales_ppo.total_var_on_order_cost = ((retail_total_var_on_order_cost || 0) + (transfer_total_var_on_order_cost || 0)).round(2)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0) + (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = ((retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)).round(2)
             sales_ppo.correction = ((((retail_correction.to_f * 100 )|| 0) + ((transfer_correction.to_f * 100) || 0))/ 2 ).round(2)

             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name

             sales_ppo.total_cost_per_order = ((retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )).round(2)
             sales_ppo.cost_per_order = ((retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )).round(2)
             sales_ppo.total_profit = ((retail_total_profit || 0) + (transfer_total_profit || 0)).round(2)

             sales_ppo.cor_total_nos = ((retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)).round(2)
             # sales_ppo.profit_per_order = ((retail_profit_per_order || 0) + (transfer_profit_per_order || 0)).round(2)
             if sales_ppo.cor_total_nos.present? && sales_ppo.cor_total_nos > 0
               sales_ppo.profit_per_order = ((sales_ppo.total_profit || 0) / sales_ppo.cor_total_nos).round(2)
             else
                sales_ppo.cor_total_nos = 1
             end


           elsif results=="to"

             sales_ppo.total_sales = (transfer_total_sales || 0)
             sales_ppo.total_revenue = (transfer_total_revenue || 0)

             sales_ppo.total_nos = (transfer_total_nos || 0)
             sales_ppo.total_pieces = (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (transfer_total_product_dam_cost || 0)

             sales_ppo.total_refund = (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (transfer_total_promo_cost || 0)
             sales_ppo.total_var_cost = (transfer_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (transfer_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0).round(2)
             sales_ppo.cor_fixed_cost = (transfer_total_fixed_cost || 0)

             sales_ppo.shipping_cost = (transfer_rev_shipping_cost || 0)
             sales_ppo.correction =  (transfer_correction * 100) || 1.0 if transfer_correction.present?

             sales_ppo.postage_name = " less postage added" #postage_name

             sales_ppo.total_cost_per_order = (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (transfer_cor_total_nos || 0)

           elsif results=="retail"
             sales_ppo.total_sales = (retail_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0)

             sales_ppo.total_refund = (retail_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0)
             sales_ppo.total_var_cost = (retail_total_var_cost || 0)
             sales_ppo.total_var_on_order_cost = (retail_total_var_on_order_cost || 0)

             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0).round(2)

             sales_ppo.shipping_cost = (retail_shipping_cost || 0)
             sales_ppo.correction = (retail_correction * 100.0) || 1.0 if retail_correction.present?

             sales_ppo.postage_name = " add if not taking 100%" #postage_name

             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0)
           end

      return sales_ppo
  end
end
