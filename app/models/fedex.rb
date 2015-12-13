class Fedex
# Rs. 8 Per kg and minimum chargeable rate is Rs.80 per shipment
# Fuel Surcharge- 20% fixed
# Service Tax-As applicable
# COD surcharge-  Rs. 50
# Waybill Surcharge – Nil
attr_accessor :weight, :basic, :fuel_surcharge, :cod, :docket, :service_tax,  :sub_total, :total_charges

  def self.calculate_fedex_billing(weight, check_cod)

    weight = wieght ||= 10
    fedex_bill = Fedex.new
    fedex_bill.basic = 80 #weight * 8 || 80
    fedex_bill.fuel_surcharge = (fedex_bill.basic ||= 1) * 0.2 || 80 * 0.2 if fedex_bill.basic.present?
    fedex_bill.cod = 33 || 0 if check_cod == 10001
    fedex_bill.sub_total = (fedex_bill.basic ||= 80) + (fedex_bill.cod ||= 50) + (fedex_bill.fuel_surcharge ||= 0)
    fedex_bill.service_tax = (fedex_bill.sub_total ||= 0) * 0.14
    fedex_bill.total_charges = (fedex_bill.sub_total  ||= 0) + (fedex_bill.service_tax  ||= 0)
    return fedex_bill
  end

end

# Outside Delivery Area Surcharge - INR 500 or INR 9.0 per kg, whichever is higher
# Outside Pick  Up Area Surcharge-INR 1500 or INR 9.0 per kg,whichever is higher
# Sunday Delivery /Holiday Delivery-Higher of INR 2000 / waybill or INR15 per kg
# Address Correction Charges INR 50.0 / waybill
# Freight On Value (Owner’s Risk) -0.2% of the ‘Total Invoice Value’of Goods
# Freight On Value (Carrier’s Risk)- Higher of INR 100.0 or 2% of Total Invoice Value
# Hold At FedEx Location INR 8.0 per kg (applicable up to 3days) If permitted beyond 3 days: Storage Fees @ INR 10.0 per kg are levied / payable from Day 4 onwards. After 7 days, consignment is sent back to origin.
# Advancement Fee (Octroi / State Entry DutyService Charge)- Higher of INR 100.0 or 5% of the Octroi Paid
