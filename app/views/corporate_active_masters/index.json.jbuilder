json.array!(@corporate_active_masters) do |corporate_active_master|
  json.extract! corporate_active_master, :id, :name, :sort_order, :description
  json.url corporate_active_master_url(corporate_active_master, format: :json)
end
