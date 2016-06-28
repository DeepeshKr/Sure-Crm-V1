json.array!(@payumoney_statuses) do |payumoney_status|
  json.extract! payumoney_status, :id, :name, :priority_no, :external_description, :valid_payment, :description
  json.url payumoney_status_url(payumoney_status, format: :json)
end
