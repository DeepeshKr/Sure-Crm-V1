class SalesPpoProductAlert < ActiveRecord::Base
  belongs_to :product_list , foreign_key: "product_list_id"
  validates :product_list_id, presence: true, uniqueness: {
    message: "You have already added the product, no need to keep adding!" }
end
