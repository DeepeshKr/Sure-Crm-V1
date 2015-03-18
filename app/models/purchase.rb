class PURCHASE < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'PURCHASE' 
#PURCHASE
end