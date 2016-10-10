class CustomerAddress < ActiveRecord::Base
  belongs_to :address_valid, foreign_key: 'valid_id'
  belongs_to :address_type, foreign_key: 'addresstypeid'
  belongs_to :customer, foreign_key: 'customer_id' #, polymorphic: true
  has_many :order_master, foreign_key: "customer_address_id"
  
 validates :address1,  presence: true, length: { maximum: 50 }
 validates :state,  presence: true, length: { maximum: 50 }
 validates :city,  presence: true, length: { maximum: 50 }

  def st
    if self.state.upcase == 'MAHARASHTRA'
    	'MAH'
    else
    	'OTH'
    end
  end

  def state_code
    states = State.where("UPPER(NAME) = ?", self.state.upcase)
    return nil if states.blank?
    return states.first.short_code
  end
  
end
