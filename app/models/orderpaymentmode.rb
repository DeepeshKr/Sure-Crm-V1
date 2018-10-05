class Orderpaymentmode < ActiveRecord::Base
   validates :payment_cost, :inclusion => { :in => 0.0..1.0, :message => "The payment cost should be between 0 and 1"}, allow_blank: true
   validates :charges, :inclusion => { :in => -1.0..1.0, :message => "The Charges cost should be between 0 and 1"}, allow_blank: true
   #, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
    
   has_many :order_master,  foreign_key: "orderpaymentmode_id"
   has_many :order_payment,  foreign_key: "orderpaymentmode_id"
   has_many :marketing_message, foreign_key: "order_paymentmodeid"
end
