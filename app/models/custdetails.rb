class  CUSTDETAILS < ActiveRecord::Base
		if Rails.env == "development"
    	establish_connection :development_cccrm
  	elsif Rails.env == "production"
    	establish_connection :production_cccrm
  	end
  #establish_connection "#{Rails.env}_cccrm"
  self.table_name = 'CUSTDETAILS' 
  
  def order_status
    OrderMaster.find_by_external_order_no(self.ordernum).order_status_master.name
  end
  
  def payment_mode
    OrderMaster.find_by_external_order_no(self.ordernum).orderpaymentmode.name if OrderMaster.find_by_external_order_no(self.ordernum).orderpaymentmode
  end
  
  def actual_order_date
   OrderMaster.find_by_external_order_no(self.ordernum).orderdate || "Not found" if OrderMaster.find_by_external_order_no(self.ordernum).present?
  end
  
  def order_user
    OrderMaster.find_by_external_order_no(self.ordernum).employee.first_name || "Not found" if OrderMaster.find_by_external_order_no(self.ordernum).employee.present?
  end
  
  def order_ref
    OrderMaster.find_by_external_order_no(self.ordernum).id
  end
end