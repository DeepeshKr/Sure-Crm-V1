class AddressType < ActiveRecord::Base
  has_many :customer_address
end
