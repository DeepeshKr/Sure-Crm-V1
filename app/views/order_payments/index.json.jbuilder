json.array!(@order_payments) do |order_payment|
  json.extract! order_payment, :id, :order_master_id, :ref_no, :orderpaymentmode_id, :paid_date, :name, :description
  json.url order_payment_url(order_payment, format: :json)
end
