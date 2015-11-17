class Fedex < ActiveRecord::Base

# Rate Rs. 10 per kg. (all across India)
# Min charges 10 kgs.
# COD charges flat Rs. 50
# Docket Rs. 40
attr_accessor :min, :basic, :cod, :docket, :service_tax, :total_charges

def min
	return 100
end

end

