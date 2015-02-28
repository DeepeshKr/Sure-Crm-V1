class  ROPUPSPROD < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'ROPUPSPROD' 
end
