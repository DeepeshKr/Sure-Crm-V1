class  CUSTDETAILS < ActiveRecord::Base
  establish_connection "#{Rails.env}_ccview"
  self.table_name = 'CUSTDETAILS' 
end