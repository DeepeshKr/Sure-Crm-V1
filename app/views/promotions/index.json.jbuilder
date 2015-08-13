json.array!(@promotions) do |promotion|
  json.extract! promotion, :id, :name, :description, :start_hr, :start_min, :end_hr, :end_min, :start_date, :end_date, :media_id, :min_sale_value, :discount_percent, :discount_value, :free_product_list_id, :active, :unique_code, :promo_cost
  json.url promotion_url(promotion, format: :json)
end
