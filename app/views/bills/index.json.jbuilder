json.array!(@bills) do |bill|
  json.extract! bill, :id, :billno, :fordate, :orderid, :fy
  json.url bill_url(bill, format: :json)
end
