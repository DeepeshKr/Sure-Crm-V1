class AddOrderIdIndexToPayumoneyDetail < ActiveRecord::Migration
  def change
    #add_index :payumoney_details, :paymentId, name: 'payu_det_indx_payment_id' 
    #add_index :payumoney_details, :merchantTransactionId
    #add_index :payumoney_details, :customerMobileNumber
    #add_index :payumoney_details, :orderid
  end
end
