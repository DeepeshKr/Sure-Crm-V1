class SalesPpo < ActiveRecord::Base
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
  
  attr_accessor :ppo_details, :total_sales, :total_revenue, :total_nos, :total_pieces, :total_product_cost, :total_product_dam_cost, :total_refund, :total_promo_cost, :total_var_cost, :total_fixed_cost, :total_cost_per_order, 
  :cost_per_order, :total_profit, :profit_per_order, :total_transfer_order_revenue, :transfer_order_revenue, 
  :shipping_cost, :correction, :combined_fixed_cost, :postage_name, :cor_total_nos
  
  def ppo_details campaign_playlist_id, show_all=true, transfer_order=false, correct=100.0
    
    correction = (correct.to_f / 100).to_f
    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    combined_fixed_cost = campaign_playlist.cost
    
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    
     sales_ppos = SalesPpo.where('order_status_id > 10002')
          .where(campaign_playlist_id: campaign_playlist_id)
          .order("start_time")
          
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
          
          #order_status_id
          reverse_correction = 1.0 - correction
          # total postage cost
         shipping_cost = 0
         rev_shipping_cost = 0
          # tranfer order 10020
          # tranfer order delivered 10041
          # tranfer order cancelled 10040
          total_transfer_order_revenue = 0
          rev_shipping_cost = 0
          
          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')
        
          if transfer_order==true
             postage_name = "Charge Reversal"
             sales_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
             
             total_sales = (sales_ppos.sum(:gross_sales)  * correction).round(2)
             total_nos = (sales_ppos.distinct.count('order_id') * correction).round(2)
             total_pieces = (sales_ppos.sum(:pieces)  * correction).round(2) 
             total_revenue = (sales_ppos.sum(:revenue) * correction).round(2) 
             total_product_cost = (sales_ppos.sum(:product_cost) * correction).round(2) 
             total_var_cost = (sales_ppos.sum(:commission_cost) * correction).round(2) 
             net_sale = (sales_ppos.sum(:net_sale) * correction).round(2) 
         
             
             total_transfer_order_revenue = (sales_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * correction.round(2)) || 0
             
             total_revenue = (total_transfer_order_revenue).round(2) 
            
             rev_shipping_cost = (sales_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * reverse_correction).round(2)
             
             shipping_cost = rev_shipping_cost
              
             total_fixed_cost = ((campaign_playlist.cost / all_orders) * transfer_orders).round(2)
           
           elsif transfer_order==false
             
            postage_name = "Charge Correction"
            sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)
            
            total_sales = (sales_ppos.sum(:gross_sales)  * correction).round(2)
            total_nos = (sales_ppos.distinct.count('order_id') * correction).round(2)
            total_pieces = (sales_ppos.sum(:pieces)  * correction).round(2) 
            total_revenue = (sales_ppos.sum(:revenue) * correction).round(2) 
            total_product_cost = (sales_ppos.sum(:product_cost) * correction).round(2) 
            total_var_cost = (sales_ppos.sum(:commission_cost) * correction).round(2) 
            net_sale = (sales_ppos.sum(:net_sale) * correction).round(2) 
         
            total_transfer_order_revenue = 0
            #.where.not(order_status_id: tranfer_order_ids)
            shipping_cost = (sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)
            
            total_fixed_cost = ((campaign_playlist.cost / all_orders) * retail_orders).round(2)
            
            
          end
        
          ### dont correct these values they are already corrected from above
          total_product_dam_cost = (total_product_cost* 0.10).round(2)
          total_refund = (total_sales * 0.02).round(2)  
           
         
          total_cost_per_order = (total_product_cost + total_fixed_cost + total_var_cost + total_refund + total_product_dam_cost + shipping_cost + (total_promo_cost || 0)).round(2) 
          #   
          total_cost_per_order = (total_cost_per_order - (rev_shipping_cost || 0)).round(2) 
          
          #revise total nos if it is less than 1
           cor_total_nos = 1
          if total_nos.present? && total_nos > 1
            cor_total_nos = total_nos 
          end
          
          cost_per_order = (total_cost_per_order.to_f / cor_total_nos).round(2) 
          total_profit = (total_revenue - total_cost_per_order).round(2) 
          profit_per_order  = (total_profit.to_f  / cor_total_nos).round(2) 
          
          sales_ppo = SalesPpo.new
          sales_ppo.total_sales = total_sales || 0 if total_sales.present?
          sales_ppo.total_revenue = total_revenue || 0 if total_revenue.present?
          sales_ppo.total_transfer_order_revenue = total_transfer_order_revenue || 0 if total_transfer_order_revenue.present?
          sales_ppo.total_nos = total_nos || 0 if total_nos.present?
          sales_ppo.total_pieces = total_pieces || 0 if total_pieces.present?
          sales_ppo.total_product_cost = total_product_cost || 0 if total_product_cost.present?
          sales_ppo.total_product_dam_cost = total_product_dam_cost || 0 if total_product_dam_cost.present?
          sales_ppo.total_refund = total_refund || 0 if total_sales.present?
          sales_ppo.total_promo_cost = total_promo_cost || 0 if total_refund.present?
          sales_ppo.total_var_cost = total_var_cost || 0 if total_var_cost.present?
          sales_ppo.total_fixed_cost = total_fixed_cost || 0 if total_fixed_cost.present?
          
       
          sales_ppo.shipping_cost = shipping_cost 
          sales_ppo.correction = (correction * 100).to_i
          sales_ppo.combined_fixed_cost = combined_fixed_cost
          sales_ppo.postage_name = postage_name
          
          sales_ppo.total_cost_per_order = total_cost_per_order || 0 if total_cost_per_order.present?
          sales_ppo.cost_per_order = cost_per_order || 0 if cost_per_order.present?
          sales_ppo.total_profit = total_profit || 0 if total_profit.present?
          sales_ppo.profit_per_order = profit_per_order || 0 if profit_per_order.present?
          sales_ppo.cor_total_nos = cor_total_nos
          
      return sales_ppo
  end
  
  def ppo_for_date campaign_playlist_id, show_all=true, transfer_order=false, correct=100.0
    
    correction = (correct.to_f / 100).to_f
    campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
    combined_fixed_cost = campaign_playlist.cost
    
    cancelled_status_ids = [10040, 10006, 10008]
    tranfer_order_ids = [10020, 10040, 10041]
    
     sales_ppos = SalesPpo.where('order_status_id > 10002')
          .where(campaign_playlist_id: campaign_playlist_id)
          .order("start_time")
          
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
          
          #order_status_id
          reverse_correction = 1.0 - correction
          # total postage cost
         shipping_cost = 0
         rev_shipping_cost = 0
          # tranfer order 10020
          # tranfer order delivered 10041
          # tranfer order cancelled 10040
          total_transfer_order_revenue = 0
          rev_shipping_cost = 0
          
          all_orders = sales_ppos.distinct.count('order_id')
          retail_orders = sales_ppos.where.not(order_status_id: tranfer_order_ids).distinct.count('order_id')
          transfer_orders = sales_ppos.where(order_status_id: tranfer_order_ids).distinct.count('order_id')
        
          if transfer_order==true
             postage_name = "Charge Reversal"
             sales_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
             
             total_sales = (sales_ppos.sum(:gross_sales)  * correction).round(2)
             total_nos = (sales_ppos.distinct.count('order_id') * correction).round(2)
             total_pieces = (sales_ppos.sum(:pieces)  * correction).round(2) 
             total_revenue = (sales_ppos.sum(:revenue) * correction).round(2) 
             total_product_cost = (sales_ppos.sum(:product_cost) * correction).round(2) 
             total_var_cost = (sales_ppos.sum(:commission_cost) * correction).round(2) 
             net_sale = (sales_ppos.sum(:net_sale) * correction).round(2) 
         
             
             total_transfer_order_revenue = (sales_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:transfer_order_revenue) * correction.round(2)) || 0
             
             total_revenue = (total_transfer_order_revenue).round(2) 
            
             rev_shipping_cost = (sales_ppos.where(order_status_id: tranfer_order_ids)
             .sum(:shipping_cost) * reverse_correction).round(2)
             
             shipping_cost = rev_shipping_cost
              
             total_fixed_cost = ((campaign_playlist.cost / all_orders) * transfer_orders).round(2)
           
           elsif transfer_order==false
             
            postage_name = "Charge Correction"
            sales_ppos = sales_ppos.where.not(order_status_id: tranfer_order_ids)
            
            total_sales = (sales_ppos.sum(:gross_sales)  * correction).round(2)
            total_nos = (sales_ppos.distinct.count('order_id') * correction).round(2)
            total_pieces = (sales_ppos.sum(:pieces)  * correction).round(2) 
            total_revenue = (sales_ppos.sum(:revenue) * correction).round(2) 
            total_product_cost = (sales_ppos.sum(:product_cost) * correction).round(2) 
            total_var_cost = (sales_ppos.sum(:commission_cost) * correction).round(2) 
            net_sale = (sales_ppos.sum(:net_sale) * correction).round(2) 
         
            total_transfer_order_revenue = 0
            #.where.not(order_status_id: tranfer_order_ids)
            shipping_cost = (sales_ppos.sum(:shipping_cost) * reverse_correction).round(2)
            
            total_fixed_cost = ((campaign_playlist.cost / all_orders) * retail_orders).round(2)
            
            
          end
        
          ### dont correct these values they are already corrected from above
          total_product_dam_cost = (total_product_cost* 0.10).round(2)
          total_refund = (total_sales * 0.02).round(2)  
           
         
          total_cost_per_order = (total_product_cost + total_fixed_cost + total_var_cost + total_refund + total_product_dam_cost + shipping_cost + (total_promo_cost || 0)).round(2) 
          #   
          total_cost_per_order = (total_cost_per_order - (rev_shipping_cost || 0)).round(2) 
          
          #revise total nos if it is less than 1
           cor_total_nos = 1
          if total_nos.present? && total_nos > 1
            cor_total_nos = total_nos 
          end
          
          cost_per_order = (total_cost_per_order.to_f / cor_total_nos).round(2) 
          total_profit = (total_revenue - total_cost_per_order).round(2) 
          profit_per_order  = (total_profit.to_f  / cor_total_nos).round(2) 
          
          sales_ppo = SalesPpo.new
          sales_ppo.total_sales = total_sales || 0 if total_sales.present?
          sales_ppo.total_revenue = total_revenue || 0 if total_revenue.present?
          sales_ppo.total_transfer_order_revenue = total_transfer_order_revenue || 0 if total_transfer_order_revenue.present?
          sales_ppo.total_nos = total_nos || 0 if total_nos.present?
          sales_ppo.total_pieces = total_pieces || 0 if total_pieces.present?
          sales_ppo.total_product_cost = total_product_cost || 0 if total_product_cost.present?
          sales_ppo.total_product_dam_cost = total_product_dam_cost || 0 if total_product_dam_cost.present?
          sales_ppo.total_refund = total_refund || 0 if total_sales.present?
          sales_ppo.total_promo_cost = total_promo_cost || 0 if total_refund.present?
          sales_ppo.total_var_cost = total_var_cost || 0 if total_var_cost.present?
          sales_ppo.total_fixed_cost = total_fixed_cost || 0 if total_fixed_cost.present?
          
       
          sales_ppo.shipping_cost = shipping_cost 
          sales_ppo.correction = (correction * 100).to_i
          sales_ppo.combined_fixed_cost = combined_fixed_cost
          sales_ppo.postage_name = postage_name
          
          sales_ppo.total_cost_per_order = total_cost_per_order || 0 if total_cost_per_order.present?
          sales_ppo.cost_per_order = cost_per_order || 0 if cost_per_order.present?
          sales_ppo.total_profit = total_profit || 0 if total_profit.present?
          sales_ppo.profit_per_order = profit_per_order || 0 if profit_per_order.present?
          sales_ppo.cor_total_nos = cor_total_nos
          
      return sales_ppo
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
end
