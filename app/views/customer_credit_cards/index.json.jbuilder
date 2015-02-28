json.array!(@customer_credit_cards) do |customer_credit_card|
  json.extract! customer_credit_card, :id, :customer_id, :card_no, :name_on_card, :expiry_mon, :expiry_yr_string
  json.url customer_credit_card_url(customer_credit_card, format: :json)
end
