json.array!(@marketing_messages) do |marketing_message|
  json.extract! marketing_message, :id, :name, :description, :total_nos, :activate, :start_date, :end_date, :order_paymentmodeid
  json.url marketing_message_url(marketing_message, format: :json)
end
