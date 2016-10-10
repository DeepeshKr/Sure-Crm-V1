json.array!(@cust_details_tracks) do |cust_details_track|
  json.extract! cust_details_track, :id, :order_ref_id, :order_date, :ext_ref_id, :custdetails, :vpp, :dealtran, :last_call_back_on, :no_of_attempts, :mobile, :alt_mobile, :products, :current_status
  json.url cust_details_track_url(cust_details_track, format: :json)
end
