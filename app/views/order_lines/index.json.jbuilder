json.array!(@order_lines) do |order_line|
  json.extract! order_line, :id, :orderid, :orderdate, :employeecode, :employee_id, :external_ref_no, :productvariant_id, :pieces, :subtotal, :taxes, :shipping, :codcharges, :total, :orderlinestatusmaster_id, :productline_id, :description, :estimatedshipdate, :estimatedarrivaldate, :orderchecked, :actualshippate
  json.url order_line_url(order_line, format: :json)
end
