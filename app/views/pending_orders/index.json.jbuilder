json.array!(@pending_orders) do |pending_order|
  json.extract! pending_order, :id, :order_ref_id, :order_no, :order_dispatch_status_id, :cod_amount, :cod_amount, :pay_u_amount, :pay_u_amount, :courier_list_id, :pay_u_status_id
  json.url pending_order_url(pending_order, format: :json)
end
