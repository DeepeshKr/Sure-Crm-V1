class  TEMPINV_NEWWLSDET < ActiveRecord::Base
  establish_connection "#{Rails.env}_tuview"
  self.table_name = 'TEMPINV_NEWWLSDET' 
end