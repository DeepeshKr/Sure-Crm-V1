class  NEW_DEPT < ActiveRecord::Base
	if Rails.env == "development"
    	establish_connection :development_cccrm
  	elsif Rails.env == "production"
    	establish_connection :production_cccrm
  	end
  #establish_connection "#{Rails.env}_cccrm"
  #wholesale return
  def self.inheritance_column
    nil
  end
  self.table_name = 'NEW_DEPT' 
  alias_attribute :tran_type, :type
  #TYPE='WLS'
  #CASESTATUS ='CLOSED'
end