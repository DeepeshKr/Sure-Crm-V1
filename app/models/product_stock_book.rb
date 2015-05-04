class ProductStockBook < ActiveRecord::Base
  belongs_to :product_master, foreign_key: "product_master_id"
  validates :ext_prod_code, :stock_date,  presence: true
  validates_uniqueness_of :stock_date, :scope => :ext_prod_code, :message => "There is already an entry for Date for the Product!" 
end
