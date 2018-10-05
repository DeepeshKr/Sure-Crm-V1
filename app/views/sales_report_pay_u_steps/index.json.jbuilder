json.array!(@sales_report_pay_u_steps) do |sales_report_pay_u_step|
  json.extract! sales_report_pay_u_step, :id, :name, :description, :min_value, :max_value, :active
  json.url sales_report_pay_u_step_url(sales_report_pay_u_step, format: :json)
end
