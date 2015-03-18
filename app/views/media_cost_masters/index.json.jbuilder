json.array!(@media_cost_masters) do |media_cost_master|
  json.extract! media_cost_master, :id, :name, :duration_secs, :cost_per_sec, :media_id, :str_hr, :str_min, :str_sec, :end_hr, :end_min, :end_sec, :description
  json.url media_cost_master_url(media_cost_master, format: :json)
end
