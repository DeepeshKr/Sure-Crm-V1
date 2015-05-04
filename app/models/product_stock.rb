class ProductStock < ActiveRecord::Base
  validates :ext_prod_code ,  :presence => { :message => "Please select product from list above!" }
  validates :current_stock, numericality: { only_integer: true },  :presence => { :message => "Please add no of pieces!" }
  validates :checked_date,  :presence => { :message => "Please select a date!" }

end
