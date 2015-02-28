class AddressType < ActiveRecord::Base
  has_many :customer_address, foreign_key: 'addresstypeid'
end
