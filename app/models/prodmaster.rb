class PRODMASTER < ActiveRecord::Base
  #establish_connection "#{Rails.env}_tuview"

  	if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  self.table_name = 'PRODMASTER' 

end

