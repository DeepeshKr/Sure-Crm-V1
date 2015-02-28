json.array!(@order_masters) do |order_master|
  json.extract! order_master, :id, :orderdate, :employeecode, :employee_id, :customer_id, :customer_address_id, :billno, :external_order_no, :pieces, :subtotal, :taxes, :shipping, :codcharges, :total, :orderstatusmaster_id, :orderpaymentmode_id, :campaignplaylist_id, :notes
  json.url order_master_url(order_master, format: :json)
end
