class TransDetails < ActiveRecord::Base
	if Rails.env == "development"
		establish_connection :development_sql_tpl_mall
	elsif Rails.env == "production"
		establish_connection :production_sql_tpl_mall
	end
	self.table_name = 'TransDetails'
   	alias_attribute :tid, :Tid
   	alias_attribute :order_date, :OrderDate
  	alias_attribute :order_no, :OrderNo
  	alias_attribute :channel, :Channel
  	alias_attribute :product, :Product
  	alias_attribute :amount, :Amount
  	alias_attribute :shipped, :Shipped
  	alias_attribute :paid, :Paid
  	alias_attribute :return, :Return
  	alias_attribute :refund, :Refund
  	alias_attribute :customer_name, :CustomerName
  	alias_attribute :city, :City
  	alias_attribute :comm, :Comm
    
    def online_records calledno, from_date, to_date
      order_masters_order_nos = OrderMaster.where(calledno: calledno)
          .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', from_date, to_date)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .order("orderdate DESC")
          .limit(100).pluck(:external_order_no)
          
      trans_details =  TransDetails.where(order_no: order_masters_order_nos).limit(100)
      
    end
   
end
 