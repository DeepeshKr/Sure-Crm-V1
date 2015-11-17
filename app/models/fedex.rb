class Fedex < ActiveRecord::Base
# Rs. 8 Per kg and minimum chargeable rate is Rs.80 per shipment

# Fuel Surcharge- 20% fixed
# Service Tax-As applicable
# COD surcharge-  Rs. 50
# Waybill Surcharge – Nil
attr_accessor :min, :basic, :surcharge, :cod, :service_tax, :total_charges

def min
	return 80
end

def basic
	return 80
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