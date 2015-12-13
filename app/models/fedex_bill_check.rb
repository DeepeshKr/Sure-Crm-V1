class FedexBillCheck < ActiveRecord::Base
require 'csv'
require 'roo'
 #validates :shipreference,  allow_nil: true, uniqueness: true
 #validates_presence_of :ref_name

  def self.import(file, ref_name)
    t = Time.zone.now + 330.minutes
    #spreadsheet = open_spreadsheet(file)
      CSV.foreach(file.path, headers: true) do |row|

        fedex_bill_check_hash = row.to_hash # exclude the price field
        manifest_no = fedex_bill_check_hash["ShipReference"]
        fedex_bill_checks = FedexBillCheck.where(shipreference: manifest_no)
        comments = ref_name ||= "Nothing there"
        products = []
        tot_weight = 0.0
        order_ref_no = nil
        order_no = nil
        manifest_no = manifest_no || nil if manifest_no.match(/[mM]\d*/)
        if manifest_no.present?

          vpp_prod = VPP.where(manifest: manifest_no) #.pluck(:custref, :prod)
          if vpp_prod.present?
            order_no = vpp_prod.first.custref
            order_master = OrderMaster.where(external_order_no: order_no)
            order_ref_no = order_master.first.id
            #custref         #external_order_no
            vpp_prod.each do |vpr|
              product_master =	ProductMaster.where(extproductcode: vpr.prod)
              if product_master.present?
                tot_weight += product_master.first.weight_kg ||= 0
                products << product_master.first.extproductcode + " " + product_master.first.weight_kg.to_s ||= "0"
              end
            end
          end
          order_payment_id = order_master.first.orderpaymentmode_id || 0 if order_master.present?
          fedex_cal = Fedex.calculate_fedex_billing(tot_weight, order_payment_id)
          weight_diff = tot_weight - (fedex_bill_check_hash["Weight"]).to_f
        end #end manifest check
    if fedex_bill_checks.present?
      fedex_bill_check = fedex_bill_checks.first
      fedex_bill_check.update(:shp_cust_nbr => fedex_bill_check_hash["shp_cust_nbr"], :acctno => fedex_bill_check_hash["AcctNo"], :invno => fedex_bill_check_hash["InvNo"], :invdate => Date.strptime(fedex_bill_check_hash["InvDate"], "%m/%d/%y"), :awb => fedex_bill_check_hash["AWB"], :shipdate => Date.strptime(fedex_bill_check_hash["Shipdate"], "%m/%d/%y"), :shprname => fedex_bill_check_hash["ShprName"], :coname => fedex_bill_check_hash["CoName"], :shipadd => fedex_bill_check_hash["ShipAdd"], :shprlocation => fedex_bill_check_hash["ShprLocation"], :shp_postal_code => fedex_bill_check_hash["Shp_Postal_Code"], :shipreference => fedex_bill_check_hash["ShipReference"], :origloc => fedex_bill_check_hash["OrigLoc"], :origctry => fedex_bill_check_hash["OrigCtry"], :destloc => fedex_bill_check_hash["DestLoc"], :destctry => fedex_bill_check_hash["DestCtry"], :svc1 => fedex_bill_check_hash["Svc1"], :pcs => fedex_bill_check_hash["Pcs"], :weight => fedex_bill_check_hash["Weight"], :dimwgt => fedex_bill_check_hash["Dimwgt"], :wgttype => fedex_bill_check_hash["WgtType"], :dimflag => fedex_bill_check_hash["DIMFlag"], :billflag => fedex_bill_check_hash["BillFlag"], :ratedamt => fedex_bill_check_hash["RatedAmt"], :discount => fedex_bill_check_hash["Discount"], :address_correction => fedex_bill_check_hash["Address_Correction"], :cod_fee => fedex_bill_check_hash["COD_Fee"], :freight_on_value_carriers_risk => fedex_bill_check_hash["Freight_on_Value_Carriers_Risk"], :freight_on_value_own_risk => fedex_bill_check_hash["Freight_on_Value_Own_Risk"], :fuel_surcharge => fedex_bill_check_hash["Fuel_Surcharge"], :higher_floor_delivery => fedex_bill_check_hash["Higher_Floor_Delivery"], :india_service_tax => fedex_bill_check_hash["India_Service_Tax"], :out_of_delivery_area => fedex_bill_check_hash["Out of Delivery Area"], :billedamt => fedex_bill_check_hash["BilledAmt"], :recp_pstl_cd => fedex_bill_check_hash["recp_pstl_cd"], :verif_name => comments, :verif_order_ref_id => order_ref_no, :verif_order_no => order_no, :verif_products => products, :verif_weight => tot_weight, :verif_weight_diff => weight_diff, :verif_comments => comments, :verif_basic => (fedex_cal.basic || 0 if fedex_cal.present?), :verif_fuel_surcharge => (fedex_cal.fuel_surcharge || 0 if fedex_cal.present?), :verif_cod => (fedex_cal.cod || 0 if fedex_cal.present?), :verif_service_tax => (fedex_cal.service_tax || 0 if fedex_cal.present?), :verif_total_charges => (fedex_cal.total_charges || 0 if fedex_cal.present?))
    else
       FedexBillCheck.create(:shp_cust_nbr => fedex_bill_check_hash["shp_cust_nbr"], :acctno => fedex_bill_check_hash["AcctNo"], :invno => fedex_bill_check_hash["InvNo"], :invdate => Date.strptime(fedex_bill_check_hash["InvDate"], "%m/%d/%y"), :awb => fedex_bill_check_hash["AWB"], :shipdate => Date.strptime(fedex_bill_check_hash["Shipdate"], "%m/%d/%y"), :shprname => fedex_bill_check_hash["ShprName"], :coname => fedex_bill_check_hash["CoName"], :shipadd => fedex_bill_check_hash["ShipAdd"], :shprlocation => fedex_bill_check_hash["ShprLocation"], :shp_postal_code => fedex_bill_check_hash["Shp_Postal_Code"], :shipreference => fedex_bill_check_hash["ShipReference"], :origloc => fedex_bill_check_hash["OrigLoc"], :origctry => fedex_bill_check_hash["OrigCtry"], :destloc => fedex_bill_check_hash["DestLoc"], :destctry => fedex_bill_check_hash["DestCtry"], :svc1 => fedex_bill_check_hash["Svc1"], :pcs => fedex_bill_check_hash["Pcs"], :weight => fedex_bill_check_hash["Weight"], :dimwgt => fedex_bill_check_hash["Dimwgt"], :wgttype => fedex_bill_check_hash["WgtType"], :dimflag => fedex_bill_check_hash["DIMFlag"], :billflag => fedex_bill_check_hash["BillFlag"], :ratedamt => fedex_bill_check_hash["RatedAmt"], :discount => fedex_bill_check_hash["Discount"], :address_correction => fedex_bill_check_hash["Address_Correction"], :cod_fee => fedex_bill_check_hash["COD_Fee"], :freight_on_value_carriers_risk => fedex_bill_check_hash["Freight_on_Value_Carriers_Risk"], :freight_on_value_own_risk => fedex_bill_check_hash["Freight_on_Value_Own_Risk"], :fuel_surcharge => fedex_bill_check_hash["Fuel_Surcharge"], :higher_floor_delivery => fedex_bill_check_hash["Higher_Floor_Delivery"], :india_service_tax => fedex_bill_check_hash["India_Service_Tax"], :out_of_delivery_area => fedex_bill_check_hash["Out_of_Delivery_Area"], :billedamt => fedex_bill_check_hash["BilledAmt"], :recp_pstl_cd => fedex_bill_check_hash["recp_pstl_cd"], :verif_name => comments, :verif_order_ref_id => order_ref_no, :verif_order_no => order_no, :verif_products => products, :verif_weight => tot_weight, :verif_weight_diff => weight_diff, :verif_comments => comments, :verif_basic => (fedex_cal.basic || 0 if fedex_cal.present?), :verif_fuel_surcharge => (fedex_cal.fuel_surcharge || 0 if fedex_cal.present?), :verif_cod => (fedex_cal.cod || 0 if fedex_cal.present?), :verif_service_tax => (fedex_cal.service_tax || 0 if fedex_cal.present?), :verif_total_charges => (fedex_cal.total_charges || 0 if fedex_cal.present?), :verif_upload_date => t)
    end # end if !pincode_list.nil?
  end # end CSV.foreach
end # end self.import(file)

# def self.import(file)
#   allowed_attributes = ["identifier","first_name","last_name","address","phone"]
#   spreadsheet = open_spreadsheet(file)
#   header = spreadsheet.row(1)
#   (2..spreadsheet.last_row).each do |i|
#     row = Hash[[header, spreadsheet.row(i)].transpose]
#     employee = find_by_identifier(row["identifier"]) || new
#     employee.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
#     employee.save!
#   end
# end
#
# def self.open_spreadsheet(file)
#   case File.extname(file.original_filename)
#   when ".csv" then Roo::Csv.new(file.path, :ignore)
#   when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
#   when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
#   else raise "Unknown file type: #{file.original_filename}"
#   end
#
# end
#spreadsheet = open_spreadsheet(file)
#use this to open file
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, extension: :csv)
    when ".xls" then Roo::Excel.new(file.path, extension: :xls)
    when ".xlsx" then Roo::Excelx.new(file.path, extension: :xlsx)
    else raise "Unknown file type: #{file.original_filename}"
    end

  end

  def self.calculate_fedex_billing(weight)
    # Rs. 8 Per kg and minimum chargeable rate is Rs.80 per shipment
    # Fuel Surcharge- 20% fixed
    # Service Tax-As applicable
    # COD surcharge-  Rs. 50
    # Waybill Surcharge – Nil
    weight = wieght ||= 10
    fedex_bill = Fedex.new
    fedex_bill.basic = 80 #weight * 8 || 80
    fedex_bill.fuel_surcharge = (fedex_bill.basic ||= 1) * 0.2 || 80 * 0.2 if fedex_bill.basic.present?
    fedex_bill.cod = 33 || 0 if weight.present?
    fedex_bill.sub_total = (fedex_bill.basic ||= 80) + (fedex_bill.cod ||= 50) + (fedex_bill.fuel_surcharge ||= 0)
    fedex_bill.service_tax = fedex_bill.sub_total * 0.14
    fedex_bill.total_charges = fedex_bill.sub_total + fedex_bill.service_tax
    return fedex_bill
  end
end
  #  fedex_bill_checks.update(:shp_cust_nbr => fedex_bill_check_hash["shp_cust_nbr"], :acctno => fedex_bill_check_hash["AcctNo"], :invno => fedex_bill_check_hash["InvNo"], :invdate => Date.strptime(fedex_bill_check_hash["InvDate"], "%m/%d/%y"), :awb => fedex_bill_check_hash["AWB"], :shipdate => Date.strptime(fedex_bill_check_hash["Shipdate"], "%m/%d/%y"), :shprname => fedex_bill_check_hash["ShprName"], :coname => fedex_bill_check_hash["CoName"], :shipadd => fedex_bill_check_hash["ShipAdd"], :shprlocation => fedex_bill_check_hash["ShprLocation"], :shp_postal_code => fedex_bill_check_hash["Shp_Postal_Code"], :shipreference => fedex_bill_check_hash["ShipReference"], :origloc => fedex_bill_check_hash["OrigLoc"], :origctry => fedex_bill_check_hash["OrigCtry"], :destloc => fedex_bill_check_hash["DestLoc"], :destctry => fedex_bill_check_hash["DestCtry"], :svc1 => fedex_bill_check_hash["Svc1"], :pcs => fedex_bill_check_hash["Pcs"], :weight => fedex_bill_check_hash["Weight"], :dimwgt => fedex_bill_check_hash["Dimwgt"], :wgttype => fedex_bill_check_hash["WgtType"], :dimflag => fedex_bill_check_hash["DIMFlag"], :billflag => fedex_bill_check_hash["BillFlag"], :ratedamt => fedex_bill_check_hash["RatedAmt"], :discount => fedex_bill_check_hash["Discount"], :address_correction => fedex_bill_check_hash["Address Correction"], :cod_fee => fedex_bill_check_hash["COD Fee"], :freight_on_value_carriers_risk => fedex_bill_check_hash["Freight on Value Carriers Risk "], :freight_on_value_own_risk => fedex_bill_check_hash["Freight on Value Own Risk"], :fuel_surcharge => fedex_bill_check_hash["Fuel Surcharge"], :higher_floor_delivery => fedex_bill_check_hash["Higher Floor Delivery"], :india_service_tax => fedex_bill_check_hash["India Service Tax"], :out_of_delivery_area => fedex_bill_check_hash["Out of Delivery Area"], :billedamt => fedex_bill_check_hash["BilledAmt"], :recp_pstl_cd => fedex_bill_check_hash["recp_pstl_cd"], :verif_name => comments, :verif_order_ref_id => order_ref_no, :verif_order_no => order_no, verif_products: products, verif_weight: tot_weight, :verif_weight_diff => weight_diff, :verif_comments => comments, :verif_basic => fedex_cal.basic, :verif_fuel_surcharge => fedex_cal.fuel_surcharge, :verif_cod => fedex_cal.cod, :verif_service_tax => fedex_cal.service_tax, :verif_total_charges => fedex_cal.total_charges)
#shp_cust_nbr	AcctNo	InvNo	InvDate	AWB	Shipdate	ShprName	CoName	ShipAdd	ShprLocation	Shp_Postal_Code	ShipReference	OrigLoc	OrigCtry	DestLoc	DestCtry	Svc1	Pcs	Weight	Dimwgt	WgtType	DIMFlag	BillFlag	 RatedAmt 	 Discount 	 Address Correction 	 COD Fee 	 Freight on Value Carriers Risk 	 Freight on Value Own Risk 	 Fuel Surcharge 	 Higher Floor Delivery 	 India Service Tax 	 Out of Delivery Area 	 BilledAmt 	recp_pstl_cd

#  params.require(:fedex_bill_check).permit(:shp_cust_nbr, :acctno, :invno, :invdate, :awb, :shipdate, :shprname, :coname, :shipadd, :shprlocation, :shp_postal_code, :shipreference, :origloc, :origctry, :destloc, :destctry, :svc1, :pcs, :weight, :dimwgt, :wgttype, :dimflag, :billflag, :ratedamt, :discount, :address_correction, :cod_fee, :freight_on_value_carriers_risk, :freight_on_value_own_risk, :fuel_surcharge, :higher_floor_delivery, :india_service_tax, :out_of_delivery_area, :billedamt, :recp_pstl_cd)
