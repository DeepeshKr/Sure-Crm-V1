class DNISMASTER < ActiveRecord::Base
  establish_connection "#{Rails.env}_ccview"
  self.table_name = 'DNISMASTER' 
#PURCHASE
#purchases_new
end