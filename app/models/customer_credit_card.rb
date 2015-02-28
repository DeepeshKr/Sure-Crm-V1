class CustomerCreditCard < ActiveRecord::Base
	 belongs_to :customer, foreign_key: 'customer_id'

	# #t.string :card_no
	# def last_digits    
	#   self.card_no.to_s.length <= 4 ? number : number.to_s.slice(-4..-1) 
	# end

	def mask
		firstnumber = self.card_no[0 , 4]
		lastnumber = self.card_no[self.card_no.length - 4 ,4]
	#number = self.card_no.to_s.length <= 4 ? number : number.to_s.slice(-4..-1) 
	  "#{firstnumber}-XXXX-XXXX-#{lastnumber}"
	end
end
