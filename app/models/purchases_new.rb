class PURCHASES_NEW < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'PURCHASES_NEW' 
#PURCHASE
#purchases_new
end