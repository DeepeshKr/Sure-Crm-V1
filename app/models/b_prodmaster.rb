class B_PRODMASTER < ActiveRecord::Base
  establish_connection "#{Rails.env}_ccview"
  self.table_name = 'B_PRODMASTER' 

end