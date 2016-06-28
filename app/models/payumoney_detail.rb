class PayumoneyDetail < ActiveRecord::Base
	belongs_to :order_master, foreign_key: "orderid"
	#validates_uniqueness_of :orderid
	belongs_to :payumoney_status, foreign_key: "payumoney_status_id"

	def self.store_payumoney_details(response,referenceId)
		PayumoneyDetail.create(:status => response["status"],
			:paymentId => response["result"]["paymentId"],
			:amount  => response["result"]["amount"],
			:customerMobileNumber =>response["result"]["customerMobileNumber"],
			:orderid => referenceId,
			:merchantTransactionId => response["result"]["merchantTransactionId"])
	end
end
