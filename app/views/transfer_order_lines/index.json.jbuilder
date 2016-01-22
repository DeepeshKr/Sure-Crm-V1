json.array!(@transfer_order_lines) do |transfer_order_line|
  json.extract! transfer_order_line, :id, :transfer_order_id, :prod, :description, :product_list_id, :product_variant_id, :product_master_id, :pieces, :sub_total, :shipping, :codcharges, :total, :transfer_order_status_id, :notes
  json.url transfer_order_line_url(transfer_order_line, format: :json)
end
