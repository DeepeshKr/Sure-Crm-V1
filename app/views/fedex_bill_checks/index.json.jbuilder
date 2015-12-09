json.array!(@fedex_bill_checks) do |fedex_bill_check|
  json.extract! fedex_bill_check, :id, :shp_cust_nbr, :acctno, :invno, :invdate, :awb, :shipdate, :shprname, :coname, :shipadd, :shprlocation, :shp_postal_code, :shipreference, :origloc, :origctry, :destloc, :destctry, :svc1, :pcs, :weight, :dimwgt, :wgttype, :dimflag, :billflag, :ratedamt, :discount, :address_correction, :cod_fee, :freight_on_value_carriers_risk, :freight_on_value_own_risk, :fuel_surcharge, :higher_floor_delivery, :india_service_tax, :out_of_delivery_area, :billedamt, :recp_pstl_cd
  json.url fedex_bill_check_url(fedex_bill_check, format: :json)
end
