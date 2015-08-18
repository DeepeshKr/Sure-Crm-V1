json.array!(@page_trails) do |page_trail|
  json.extract! page_trail, :id, :name, :order_id, :page_id, :url, :employee_id, :duration_secs
  json.url page_trail_url(page_trail, format: :json)
end
