json.array!(@sales_ppos) do |sales_ppo|
  json.extract! sales_ppo, :id, :campaign_playlist_id, :campaign_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :name, :start_time, :order_id, :order_line_id, :product_cost, :pieces, :revenue, :damages, :returns, :commission_cost, :promotion_cost, :media_cost, :gross_sales, :net_sale, :external_order_no, :order_status_id, :order_last_mile_id, :order_pincode, :media_id, :media_cost_total, :promo_cost_total, :dnis, :city, :state, :mobile_no
  json.url sales_ppo_url(sales_ppo, format: :json)
end
