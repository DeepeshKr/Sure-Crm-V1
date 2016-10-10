json.array!(@cust_details_track_logs) do |cust_details_track_log|
  json.extract! cust_details_track_log, :id, :cust_details_track_id, :name, :description
  json.url cust_details_track_log_url(cust_details_track_log, format: :json)
end
