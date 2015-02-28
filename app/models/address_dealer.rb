class ADDRESS_DEALER < ActiveRecord::Base
  establish_connection "#{Rails.env}_ccview"
  self.table_name = 'ADDRESS_DEALER' 

end