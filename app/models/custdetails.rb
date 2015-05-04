class  CUSTDETAILS < ActiveRecord::Base
  establish_connection "#{Rails.env}_cccrm"
  self.table_name = 'CUSTDETAILS' 
end