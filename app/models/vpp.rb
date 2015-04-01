class  VPP < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'VPP' 
end