json.array!(@tax_rates) do |tax_rate|
  json.extract! tax_rate, :id, :name, :value, :reverse, :description
  json.url tax_rate_url(tax_rate, format: :json)
end
