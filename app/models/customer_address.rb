class CustomerAddress < ActiveRecord::Base
  belongs_to :address_valid
  belongs_to :address_type
  belongs_to :customer
  
 validates :address1,  presence: true, length: { maximum: 50 }
 validates :state,  presence: true, length: { maximum: 50 }
 validates :city,  presence: true, length: { maximum: 50 }
end
