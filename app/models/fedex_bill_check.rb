class FedexBillCheck < ActiveRecord::Base
require 'csv'
 validates :shipreference,  allow_nil: true, uniqueness: true

  def self.import(file, ref_name)
      CSV.foreach(file.path, headers: true) do |row|

        fedex_bill_check_hash = row.to_hash # exclude the price field
        fedex_bill_checks = FedexBillCheck.where(shipreference: fedex_bill_check_hash["ShipReference"])

        products = []
        tot_weight = 0.0
        vpp_prod = VPP.where(manifest: @manifest).pluck(:prod)
        if vpp_prod.present?
          vpp_prod.each do |vpr|
            product_master =	ProductMaster.where(extproductcode: vpr)
            if product_master.present?
              tot_weight += product_master.first.weight_kg
              products << product_master.first.extproductcode + " " + product_master.first.weight_kg
            end
          end
        end


    if fedex_bill_checks.present?
       fedex_bill_checks.update(:shp_cust_nbr => fedex_bill_check_hash["shp_cust_nbr"], :acctno => fedex_bill_check_hash["AcctNo"], :invno => fedex_bill_check_hash["InvNo"], :invdate => fedex_bill_check_hash["InvDate"], :awb => fedex_bill_check_hash["AWB"], :shipdate => fedex_bill_check_hash["Shipdate"], :shprname => fedex_bill_check_hash["ShprName"], :coname => fedex_bill_check_hash["CoName"], :shipadd => fedex_bill_check_hash["ShipAdd"], :shprlocation => fedex_bill_check_hash["ShprLocation"], :shp_postal_code => fedex_bill_check_hash["Shp_Postal_Code"], :shipreference => fedex_bill_check_hash["ShipReference"], :origloc => fedex_bill_check_hash["OrigLoc"], :origctry => fedex_bill_check_hash["OrigCtry"], :destloc => fedex_bill_check_hash["DestLoc"], :destctry => fedex_bill_check_hash["DestCtry"], :svc1 => fedex_bill_check_hash["Svc1"], :pcs => fedex_bill_check_hash["Pcs"], :weight => fedex_bill_check_hash["Weight"], :dimwgt => fedex_bill_check_hash["Dimwgt"], :wgttype => fedex_bill_check_hash["WgtType"], :dimflag => fedex_bill_check_hash["DIMFlag"], :billflag => fedex_bill_check_hash["BillFlag"], :ratedamt => fedex_bill_check_hash["RatedAmt"], :discount => fedex_bill_check_hash["Discount"], :address_correction => fedex_bill_check_hash["Address Correction"], :cod_fee => fedex_bill_check_hash["COD Fee"], :freight_on_value_carriers_risk => fedex_bill_check_hash["Freight on Value Carriers Risk "], :freight_on_value_own_risk => fedex_bill_check_hash["Freight on Value Own Risk"], :fuel_surcharge => fedex_bill_check_hash["Fuel Surcharge"], :higher_floor_delivery => fedex_bill_check_hash["Higher Floor Delivery"], :india_service_tax => fedex_bill_check_hash["India Service Tax"], :out_of_delivery_area => fedex_bill_check_hash["Out of Delivery Area"], :billedamt => fedex_bill_check_hash["BilledAmt"], :recp_pstl_cd, => fedex_bill_check_hash["recp_pstl_cd"])
    else
       FedexBillCheck.create(prod: product_cost_master_hash["prod"],
          basic_cost: product_cost_master_hash["basic_cost"],
          shipping_handling:  product_cost_master_hash["shipping_handling"],
          product_cost:  product_cost_master_hash["product_cost"],
          postage:  product_cost_master_hash["postage"],
          tel_cost:  product_cost_master_hash["tel_cost"],
          royalty:  product_cost_master_hash["royalty"],
          cost_of_return:  product_cost_master_hash["cost_of_return"],
          call_centre_commission:  product_cost_master_hash["call_centre_commission"],
          transf_order_basic:  product_cost_master_hash["transf_order_basic"],
          dealer_network_basic:  product_cost_master_hash["dealer_network_basic"],
          wholesale_variable_cost:  product_cost_master_hash["wholesale_variable_cost"])
    end # end if !pincode_list.nil?
  end # end CSV.foreach
end # end self.import(file)


end
#shp_cust_nbr	AcctNo	InvNo	InvDate	AWB	Shipdate	ShprName	CoName	ShipAdd	ShprLocation	Shp_Postal_Code	ShipReference	OrigLoc	OrigCtry	DestLoc	DestCtry	Svc1	Pcs	Weight	Dimwgt	WgtType	DIMFlag	BillFlag	 RatedAmt 	 Discount 	 Address Correction 	 COD Fee 	 Freight on Value Carriers Risk 	 Freight on Value Own Risk 	 Fuel Surcharge 	 Higher Floor Delivery 	 India Service Tax 	 Out of Delivery Area 	 BilledAmt 	recp_pstl_cd

#  params.require(:fedex_bill_check).permit(:shp_cust_nbr, :acctno, :invno, :invdate, :awb, :shipdate, :shprname, :coname, :shipadd, :shprlocation, :shp_postal_code, :shipreference, :origloc, :origctry, :destloc, :destctry, :svc1, :pcs, :weight, :dimwgt, :wgttype, :dimflag, :billflag, :ratedamt, :discount, :address_correction, :cod_fee, :freight_on_value_carriers_risk, :freight_on_value_own_risk, :fuel_surcharge, :higher_floor_delivery, :india_service_tax, :out_of_delivery_area, :billedamt, :recp_pstl_cd)
