json.array!(@fat_to_fit_email_statuses) do |fat_to_fit_email_status|
  json.extract! fat_to_fit_email_status, :id, :emailid, :full_name, :products, :order_no, :order_id, :send_status, :last_ran_date
  json.url fat_to_fit_email_status_url(fat_to_fit_email_status, format: :json)
end
