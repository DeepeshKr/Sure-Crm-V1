class TransDetails_BKP < ActiveRecord::Base
	
   	self.table_name = 'TransDetails_BKP' 
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
end