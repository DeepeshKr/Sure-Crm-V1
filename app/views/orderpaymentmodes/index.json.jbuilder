json.array!(@orderpaymentmodes) do |orderpaymentmode|
  json.extract! orderpaymentmode, :id, :name, :description
  json.url orderpaymentmode_url(orderpaymentmode, format: :json)
end
