json.array!(@list_of_servers) do |list_of_server|
  json.extract! list_of_server, :id, :name, :description, :active_since, :internal_ip, :vpn_ip, :external_ip, :current_status
  json.url list_of_server_url(list_of_server, format: :json)
end
