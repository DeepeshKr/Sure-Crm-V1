class ProductStock < ActiveRecord::Base
  #validates :ext_prod_code ,  :presence => { :message => "Please select product from list above!" }
  validates :product_master_id ,  :presence => { :message => "Please select product from list!" }
  #validates :current_stock, numericality: { only_integer: true },  :presence => { :message => "Please add no of pieces!" }
  validates :checked_date,  :presence => { :message => "Please select a date!" }
 validates_uniqueness_of :product_master_id, :scope => [:product_master_id, :checked_date], :message => "Not Saved, you have already created an opeing stock for date! "

  belongs_to :product_master, foreign_key: "product_master_id"
end
