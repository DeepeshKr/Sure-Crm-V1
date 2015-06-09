class ProductStockAdjust < ActiveRecord::Base
	 validates :product_master_id ,  :presence => { :message => "Please select product from list!" }
  #validates :current_stock, numericality: { only_integer: true },  :presence => { :message => "Please add no of pieces!" }
  validates :created_date,  :presence => { :message => "Please select a date!" }
   validates :change_stock,  :presence => { :message => "Please enter no of pieces!" }
   validates :total,  :presence => { :message => "Please enter total value, or 0!" }
   validates :rate,  :presence => { :message => "Please enter rate or 0!" }
   validates :name,  :presence => { :message => "Please enter a heading!" }
   validates :description,  :presence => { :message => "Please enter a description!" }
	belongs_to :product_master, foreign_key: "product_master_id"
end
