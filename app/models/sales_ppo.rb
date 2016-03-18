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
  :cost_per_order, :total_profit, :profit_per_order
  
  def ppo_details campaign_playlist_id, show_all=true, transfer_order=false
    
    cancelled_status_ids = [10040, 10006, 10008]
     sales_ppos = SalesPpo.where('order_status_id > 10002')
          .where(campaign_playlist_id: campaign_playlist_id)
          .order("start_time")
          
          if show_all == false
            sales_ppos = sales_ppos.where.not(order_status_id: cancelled_status_ids)
          end
          
          #order_status_id
          # tranfer order 10020
          # tranfer order delivered 10041
          # tranfer order cancelled 10040
          if transfer_order==true
            tranfer_order_ids = [10020, 10040, 10041]
             sales_ppos = sales_ppos.where(order_status_id: tranfer_order_ids)
          end
          
          campaign_playlist =  CampaignPlaylist.find(campaign_playlist_id)
          
          total_sales = sales_ppos.sum(:gross_sales).round(2) 
          total_nos = sales_ppos.distinct.count('order_id') 
          total_pieces = sales_ppos.sum(:pieces).round(2) 
          total_revenue = sales_ppos.sum(:revenue).round(2) 
          total_product_cost = sales_ppos.sum(:product_cost).round(2) 
          total_var_cost = sales_ppos.sum(:commission_cost).round(2) 
          net_sale = sales_ppos.sum(:net_sale).round(2) 
          shipping_cost = sales_ppos.sum(:shipping_cost).round(2) 
          total_fixed_cost = campaign_playlist.cost
          total_product_dam_cost = (total_product_cost  * 0.10).round(2)
          total_refund = (total_sales * 0.02).round(2)
          total_cost_per_order = ((total_product_cost || 0)  + (total_var_cost || 0 ) +  (total_refund || 0) + (total_promo_cost || 0) + (total_product_dam_cost || 0) + (total_fixed_cost || 0)).round(2) 
          cost_per_order = ((total_cost_per_order || 0) / (total_nos || 0)).round(2) 
          total_profit = (total_revenue - total_cost_per_order).round(2) 
          profit_per_order  = (total_profit / (total_nos || 0)).round(2) 
          
          sales_ppo = SalesPpo.new
          sales_ppo.total_sales = total_sales || 0 if total_sales.present?
          sales_ppo.total_revenue = total_revenue || 0 if total_revenue.present?
          sales_ppo.total_nos = total_nos || 0 if total_nos.present?
          sales_ppo.total_pieces = total_pieces || 0 if total_pieces.present?
          sales_ppo.total_product_cost = total_product_cost || 0 if total_product_cost.present?
          sales_ppo.total_product_dam_cost = total_product_dam_cost || 0 if total_product_dam_cost.present?
          sales_ppo.total_refund = total_refund || 0 if total_sales.present?
          sales_ppo.total_promo_cost = total_promo_cost || 0 if total_refund.present?
          sales_ppo.total_var_cost = total_var_cost || 0 if total_var_cost.present?
          sales_ppo.total_fixed_cost = total_fixed_cost || 0 if total_fixed_cost.present?
          sales_ppo.total_cost_per_order = total_cost_per_order || 0 if total_cost_per_order.present?
          sales_ppo.cost_per_order = cost_per_order || 0 if cost_per_order.present?
          sales_ppo.total_profit = total_profit || 0 if total_profit.present?
          sales_ppo.profit_per_order = profit_per_order || 0 if profit_per_order.present?
    
      return sales_ppo
  end
  
  # def total_product_dam_cost
 #   total_product_cost  * 0.10
 #  end
 #
 #  def total_refund
 #    total_sales * 0.02
 #  end
 #
 #  def total_cost_per_order
 #
 #  end
 #
 #  def cost_per_order
 #    (total_cost_per_order || 0) / (total_nos || 1)
 #  end
 #
 #  def total_profit
 #     total_revenue - total_cost_per_order
 #  end
 #
 #  def profit_per_order
 #    total_profit / total_nos
 #  end
    
    
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
