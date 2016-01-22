json.array!(@transfer_order_masters) do |transfer_order_master|
  json.extract! transfer_order_master, :id, :corporate_id, :orderdate, :customer_id, :order_id, :order_no, :customer_name, :mobile, :email, :address1, :address2, :address3, :landmark, :district, :city, :state, :country, :pincode, :phone1, :phone2, :pieces, :sub_total, :shipping, :codcharges, :total, :g_total, :transfer_order_status_id, :notes
  json.url transfer_order_master_url(transfer_order_master, format: :json)
end
