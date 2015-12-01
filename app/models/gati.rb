class Gati

# Rate Rs. 10 per kg. (all across India)
# Min charges 10 kgs.
# COD charges flat Rs. 50
# Docket Rs. 40
attr_accessor :weight, :basic, :surcharge, :cod, :docket, :service_tax,  :sub_total, :total_charges

def weight
	return self.weight
end

def basic
	return 100 if (self.weight * 10) < 100
end

def cod
	return 50
end

def docket
	return 40
end

def sub_total
	return self.min + self.cod + self.docket
end

def service_tax
	return self.sub_total * 0.14
end

self total_charges
	return self.sub_total + self.service_tax
end

end
