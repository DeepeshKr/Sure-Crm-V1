class PayumoneyDetail < ActiveRecord::Base
	def self.store_payumoney_details(response,referenceId)
		PayumoneyDetail.create(:status => response["status"], 
			:paymentId => response["result"]["paymentId"], 
			:amount  => response["result"]["amount"], 
			:customerMobileNumber =>response["result"]["customerMobileNumber"], 
			:orderid => referenceId, 
			:merchantTransactionId => response["result"]["merchantTransactionId"])
	end
end
