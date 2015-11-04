json.array!(@vpp_deal_trans) do |vpp_deal_tran|
  json.extract! vpp_deal_tran, :id, :actdate, :action, :add1, :add2, :add3, :barcode
  json.url vpp_deal_tran_url(vpp_deal_tran, format: :json)
end
