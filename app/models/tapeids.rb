class TAPEIDS < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'TAPEIDS' 
#TAPEIDS
end