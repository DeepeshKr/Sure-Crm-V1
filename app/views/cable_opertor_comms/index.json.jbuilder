json.array!(@cable_opertor_comms) do |cable_opertor_comm|
  json.extract! cable_opertor_comm, :id, :order_no, :order_date, :channel, :product, :amount, :customer_name, :city, :comm, :description
  json.url cable_opertor_comm_url(cable_opertor_comm, format: :json)
end
