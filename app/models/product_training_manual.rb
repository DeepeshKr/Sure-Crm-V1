class ProductTrainingManual < ActiveRecord::Base
   belongs_to :product_training_heading, foreign_key: "product_training_heading_id"
   belongs_to :product_master, foreign_key: "productid"
end
