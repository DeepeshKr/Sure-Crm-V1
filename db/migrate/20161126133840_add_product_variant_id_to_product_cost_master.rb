class AddProductVariantIdToProductCostMaster < ActiveRecord::Migration
  def change
    add_column :product_cost_masters, :product_variant_id, :integer
    
    add_index :product_cost_masters, :product_variant_id
    add_index :product_cost_masters, :product_id
    add_index :product_cost_masters, :product_list_id
    add_index :product_cost_masters, :prod
    add_index :product_cost_masters, :barcode
    
    
    
    
     
     
  end
end
