json.array!(@change_log_trails) do |change_log_trail|
  json.extract! change_log_trail, :id, :changelogtype_id, :refid, :name, :description, :username, :ip
  json.url change_log_trail_url(change_log_trail, format: :json)
end
