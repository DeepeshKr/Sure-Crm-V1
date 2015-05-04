class IndiaPincodeList < ActiveRecord::Base
	require 'csv'

def location
	self.pincode + " " + self.taluk + " " + self.districtname
end
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      pincode_hash = row.to_hash # exclude the price field
      pincode_list = IndiaPincodeList.where(pincode: pincode_hash["pincode"])

      #if pincode_list.count == 1
      	#add execption
      	#product.first.update_attributes(product_hash.except("price"))

       # pincode_list.first.update_attributes(pincode_hash)
      #else
        IndiaPincodeList.create(pincode: pincode_hash["pincode"], officename: pincode_hash["officename"], 
        	deliverystatus:  pincode_hash["deliverystatus"], divisionname:  pincode_hash["divisionname"], 
        	regionname:  pincode_hash["regionname"], circlename:  pincode_hash["circlename"], 
        	taluk:  pincode_hash["taluk"],
        	districtname:  pincode_hash["districtname"], statename:  pincode_hash["statename"])
      #end # end if !pincode_list.nil?
    end # end CSV.foreach
  end # end self.import(file)
end
