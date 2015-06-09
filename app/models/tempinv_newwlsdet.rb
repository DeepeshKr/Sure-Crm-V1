class  TEMPINV_NEWWLSDET < ActiveRecord::Base
		if Rails.env == "development"
    	establish_connection :development_tuview
  	elsif Rails.env == "production"
    	establish_connection :production_tuview
  	end
  #establish_connection "#{Rails.env}_tuview"
  self.table_name = 'TEMPINV_NEWWLSDET' 

  #code for distributor name
  def distributor_name
  	distributor = Tbpl2003acc_Master.where(acc_code: self.distcode)
  	if distributor.present?
  		distributor.first.acc_name
  	else
  		"NA for #{self.distcode}"
  	end
  end
end