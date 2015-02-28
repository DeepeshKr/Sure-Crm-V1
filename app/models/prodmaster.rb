class PRODMASTER < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'PRODMASTER' 

end

