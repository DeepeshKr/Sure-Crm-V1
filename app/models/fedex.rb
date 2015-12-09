class Fedex
	 include ActiveModel::Model
	require 'csv'
# Rs. 8 Per kg and minimum chargeable rate is Rs.80 per shipment


# Fuel Surcharge- 20% fixed
# Service Tax-As applicable
# COD surcharge-  Rs. 50
# Waybill Surcharge – Nil
attr_accessor :weight, :basic, :fuel_surcharge, :cod, :docket, :service_tax,  :sub_total, :total_charges, :calculate_weight, :comments, :weight_difference, :products

def weight
	return self.weight
end

def products
	return self.products
end

def calculate_weight
	return self.calculate_weight
end

def weight_difference
	return self.calculate_weight - self.weight
end

def basic
	return 80 if (self.calculate_weight * 8) < 80
end

def fuel_surcharge
	return self.min * 0.2
end

def cod
	return 50
end

def sub_total
	return self.min + self.cod + self.surcharge
end

def service_tax
	return self.sub_total * 0.14
end

def total_charges
	return self.sub_total + self.service_tax
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
