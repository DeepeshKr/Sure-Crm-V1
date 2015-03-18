class TAPEIDDET < ActiveRecord::Base
  establish_connection "#{Rails.env}_ccview"
  self.table_name = 'TAPEIDDET' 
#TAPEIDS
end