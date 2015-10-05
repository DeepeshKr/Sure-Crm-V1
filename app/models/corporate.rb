class Corporate < ActiveRecord::Base
   has_one :medium

# validates_presence_of :address1, :address2, :address3, 
#         :landmark, :city, :pincode, :state, :district, 
#         :country, :telephone1, :telephone2, :fax, 
#         :website, :salute1, :first_name1, :last_name1, 
#         :designation1, :mobile1, :emaild1

attr_accessor :demo
#validates_presence_of :demo

   # name, :address1, :address2, :address3, 
   #      :landmark, :city, :pincode, :state, :district, 
   #      :country, :telephone1, :telephone2, :fax, 
   #      :website, :salute1, :first_name1, :last_name1, 
   #      :designation1, :mobile1, :emaild1, :salute2, 
   #      :first_name2, :last_name2, :designation2, 
   #      :mobile2, :emailid2, :salute3, :first_name3, 
   #      :last_name3, :designation3, :mobile3, 
   #      :emailid3, :description
end
