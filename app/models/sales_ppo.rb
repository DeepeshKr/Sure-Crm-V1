class SalesPpo < ActiveRecord::Base
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
  
  attr_accessor :ppo_details, :total_sales, :total_revenue, :total_nos, :total_pieces, 
  :total_product_cost, :total_product_dam_cost,     
  :total_refund, :total_promo_cost, :total_var_cost, :total_cost_per_order, 
  :cost_per_order, :total_profit, :profit_per_order, 
  :shipping_cost, :correction, :postage_name, :cor_total_nos,
  :total_name, :demo_date, :description,
  :total_fixed_cost, :cor_fixed_cost,
  :show, :show_time, :total_nos_1, :total_pieces_1,:total_sales_1, :total_revenue_1, :total_product_cost_1, :total_var_cost_1,
  :total_fixed_cost_1, :total_refund_1, :total_product_dam_cost_1, :profit_per_order_1, :total_name_1,
  :total_nos_2, :total_pieces_2,:total_sales_2, :total_revenue_2, :total_product_cost_2, :total_var_cost_2,
  :total_fixed_cost_2, :total_refund_2, :total_product_dam_cost_2, :profit_per_order_2, :total_name_2
  
  
  def ppo_details campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
    
      sales_ppo = SalesPpo.new    
      sales_ppo = calculate_campaign_ppo campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
      return sales_ppo
  end
  
  
  def sales_ppos_for_date for_date
    out_sales_ppos = []
    nos = 1

     
    campaign_playlists =  CampaignPlaylist.joins(:campaign)
    .where("campaigns.startdate = ?", for_date)
    .order(:start_hr, :start_min, :start_sec)
    .where(list_status_id: 10000)

    combined_fixed_cost = campaign_playlists.sum(:cost).to_f

   campaign_playlists.each do |playlist|
    campaign = Campaign.find(playlist.campaignid)
    return_rate = ReturnRate.new
    final_return_rate = return_rate.retail_best_shipped_paid_percent(playlist.productvariantid, campaign.mediumid).rate_1
    final_return_desc = return_rate.retail_best_shipped_paid_percent(playlist.productvariantid, campaign.mediumid).note_1
    # product_variant = ProductVariant.find(playlist.productvariantid).extproductcode
    # sales_ppo_1 = calculate_campaign_ppo playlist.id, false, true, true, final_return_rate, 65.00, true
    # sales_ppo_2 = calculate_campaign_ppo playlist.id, false, true, true, 25.00, 65.00, true
    # campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
   
    sales_ppo_1 = calculate_campaign_ppo playlist.id, false, true, true, final_return_rate, 65.0, "all"
#  sales_ppo_1 = calculate_campaign_ppo playlist.id, false, true, true, 100.0, 100.0, "all"
    
     sales_ppo_2 = calculate_campaign_ppo(playlist.id, false, true, true, 50.00, 65.00,"all")
#    byebug
#    total_nos_2 = sales_ppo_2.total_nos
    
    #retail_rate = final_return_rate.round(1) if final_return_rate.present?
    ret_sales_ppo = SalesPpo.new
    ret_sales_ppo.campaign_playlist_id = playlist.id
    ret_sales_ppo.prod = sales_ppo_1.prod
    ret_sales_ppo.product_cost = sales_ppo_1.product_cost
    ret_sales_ppo.total_name_1 = "R #{final_return_rate.round(1)}% | T 65%"
    ret_sales_ppo.total_name_2 = "R 50% | T 65%"
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
    
    ret_sales_ppo.description = " Row-1: #{sales_ppo_1.correction} | Row-2: #{sales_ppo_2.correction}"
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
    #string_date = for_date + " " + for_hour + ":" + for_minute + ":00"
    base_date = DateTime.strptime("#{for_date} #{for_hour}:#{for_minute}:00 + 5:30", "%Y-%m-%d %H:%M:%S")
    #return return_date = DateTime.strptime(string_date, "%Y-%m-%d %H:%M:%S")
    return (base_date - 300.minutes).strftime("%Y-%m-%d %H:%M:%S")
  end
  
  private
  def all_cancelled_orders
    cancelled_status_ids = [10040, 10006, 10008]
    #10040 => tranfer order cancelled
    #10006 => CFO cancelled at origin orders 
    #10008 => Returned Order (post shipping) / unclaimed orders
    #session[:cancelled_status_id] = @cancelled_status_id
  end
  
  def calculate_campaign_ppo campaign_playlist_id, show_all, show_shipped, transfer_order, ret_correct, to_correct, results
    
    retail_correction = (ret_correct.to_f / 100).to_f || 1.0 if ret_correct.present?
    transfer_correction = (to_correct.to_f / 100).to_f || 1.0 if to_correct.present?
     
    # byebug
    
    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    campaign = Campaign.find(campaign_playlist.campaignid)
    total_fixed_cost = campaign_playlist.cost
    
    # tranfer order 10020 tranfer order delivered 10041 tranfer order cancelled 10040
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    
     sales_ppos = SalesPpo.where('order_status_id > 10002')
          .where(campaign_playlist_id: campaign_playlist_id)
          .order("start_time")
          
          sales_ppo = SalesPpo.new
          sales_ppo.prod = sales_ppos.first.prod if sales_ppos.present?
          sales_ppo.campaign_playlist_id = sales_ppos.first.campaign_playlist_id if sales_ppos.present?
          sales_ppo.product_cost = sales_ppos.first.product_cost if sales_ppos.present?
          
           # shipped order 10005
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
           # shipped order 10005
           if show_shipped == true
             sales_ppos = sales_ppos.where('order_status_id > 10004')
           end
         # total postage cost
         # shipping_cost = 0
#          rev_shipping_cost = 0
#
#           total_transfer_order_revenue = 0
#           rev_shipping_cost = 0
          
          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')
          
          transfer_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          retail_sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)
          
          if transfer_order==true && transfer_ppos.present?
             transfer_postage_name = "Charge Reversal"
             transfer_total_sales = (transfer_ppos.sum(:gross_sales)  * transfer_correction).round(2)
             transfer_total_nos = (transfer_ppos.distinct.count('order_id') * transfer_correction).round(2)
             transfer_total_pieces = (transfer_ppos.sum(:pieces)  * transfer_correction).round(2) 
             transfer_total_revenue = (transfer_ppos.sum(:revenue) * transfer_correction).round(2) 
             transfer_total_product_cost = (transfer_ppos.sum(:product_cost) * transfer_correction).round(2) 
             transfer_total_var_cost = (transfer_ppos.sum(:commission_cost) * transfer_correction).round(2) 
             transfer_net_sale = (transfer_ppos.sum(:net_sale) * transfer_correction).round(2) 
        
             transfer_total_promo_cost = (transfer_ppos.sum(:promotion_cost) * transfer_correction).round(2) 
             
             transfer_order_total_revenue = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * transfer_correction.round(2)) || 0
             
              transfer_order_total_revenue = (transfer_order_total_revenue).round(2) 
            
             transfer_rev_shipping_cost = (transfer_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * transfer_correction).round(2)

              
             transfer_total_fixed_cost = ((total_fixed_cost / all_orders) * transfer_orders).round(2)
             
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
            
            
           elsif transfer_order==false && retail_sales_ppos.present?
              ####### retail orders are below ############
            retail_postage_name = "Charge Correction"
            
            retail_total_sales = (retail_sales_ppos.sum(:gross_sales)  * retail_correction).round(2)
            retail_total_nos = (retail_sales_ppos.distinct.count('order_id') * retail_correction).round(2)
            retail_total_pieces = (retail_sales_ppos.sum(:pieces)  * retail_correction).round(2) 
            retail_total_revenue = (retail_sales_ppos.sum(:revenue) * retail_correction).round(2) 
            retail_total_product_cost = (retail_sales_ppos.sum(:product_cost) * retail_correction).round(2) 
            retail_total_var_cost = (retail_sales_ppos.sum(:commission_cost) * retail_correction).round(2) 
            retail_net_sale = (retail_sales_ppos.sum(:net_sale) * retail_correction).round(2) 
            
            retail_total_promo_cost = (retail_sales_ppos.sum(:promotion_cost) * retail_correction).round(2) 
         
            #.where.not(order_status_id: tranfer_order_ids)
            reverse_correction = (1.0 - retail_correction).to_f
            retail_shipping_cost = (retail_sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)
            retail_total_fixed_cost = ((total_fixed_cost / all_orders) * retail_orders).round(2)
            
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
             sales_ppo.description = "Combining retail #{retail_correction * 100} and TO #{transfer_correction * 100}"
             sales_ppo.total_sales = (retail_total_sales || 0) + (transfer_total_sales || 0)
             sales_ppo.total_revenue = (retail_total_revenue || 0) + (transfer_total_revenue || 0)

             sales_ppo.total_nos = (retail_total_nos || 0) + (transfer_total_nos || 0)
             sales_ppo.total_pieces = (retail_total_pieces || 0) + (transfer_total_pieces || 0)
             sales_ppo.total_product_cost = (retail_total_product_cost || 0) + (transfer_total_product_cost || 0)
             sales_ppo.total_product_dam_cost = (retail_total_product_dam_cost || 0) + (transfer_total_product_dam_cost || 0)
             
             sales_ppo.total_refund = (retail_total_refund || 0) + (transfer_total_refund || 0)
             sales_ppo.total_promo_cost = (retail_total_promo_cost || 0) + (transfer_total_promo_cost || 0) 
             sales_ppo.total_var_cost = (retail_total_var_cost || 0) + (transfer_total_var_cost || 0) 
             sales_ppo.total_fixed_cost = (retail_total_fixed_cost || 0) + (transfer_total_fixed_cost || 0)   
             
             sales_ppo.shipping_cost = (retail_shipping_cost || 0) - (transfer_rev_shipping_cost || 0)
             sales_ppo.correction = (((retail_correction || 0) + (transfer_correction || 0))/ 2 ).round(2)
             
             sales_ppo.postage_name = " excluding Transfer Order add All Retail" #postage_name
          
             sales_ppo.total_cost_per_order = (retail_total_cost_per_order || 0 ) + (transfer_total_cost_per_order || 0 )
             sales_ppo.cost_per_order = (retail_cost_per_order || 0 ) + (transfer_cost_per_order || 0 )
             sales_ppo.total_profit = (retail_total_profit || 0) + (transfer_total_profit || 0)
             sales_ppo.profit_per_order = (retail_profit_per_order || 0) + (transfer_profit_per_order || 0)
             sales_ppo.cor_total_nos = (retail_cor_total_nos || 0) +  (transfer_cor_total_nos || 0)
           
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
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)   
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
             sales_ppo.total_fixed_cost = (total_fixed_cost || 0)  
             sales_ppo.cor_fixed_cost = (retail_total_fixed_cost || 0)   
            
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
