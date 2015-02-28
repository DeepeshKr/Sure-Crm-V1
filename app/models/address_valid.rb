class AddressValid < ActiveRecord::Base
  has_many :customer_address, foreign_key: 'valid_id'
end
