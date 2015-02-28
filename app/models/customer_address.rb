class CustomerAddress < ActiveRecord::Base
  belongs_to :address_valid, foreign_key: 'valid_id'
  belongs_to :address_type, foreign_key: 'addresstypeid'
  belongs_to :customer, foreign_key: 'customer_id' #, polymorphic: true
  has_many :order_master, foreign_key: "customer_address_id"
  
 validates :address1,  presence: true, length: { maximum: 50 }
 validates :state,  presence: true, length: { maximum: 50 }
 validates :city,  presence: true, length: { maximum: 50 }
end
