json.array!(@return_rates) do |return_rate|
  json.extract! return_rate, :id, :name, :sort_order, :total, :cancelled, :returned, :paid, :transfer_total, :transfer_paid, :transfer_cancelled, :no_of_days
  json.url return_rate_url(return_rate, format: :json)
end
