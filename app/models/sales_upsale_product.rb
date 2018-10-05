class SalesUpsaleProduct < ActiveRecord::Base
  validates_uniqueness_of :product_list_id, message: "You cannot have the same product listed twice"
  #has_one :product_list
  belongs_to :product_list, :foreign_key => 'product_list_id'
end
