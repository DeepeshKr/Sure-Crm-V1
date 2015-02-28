class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
      t.string :name
      t.integer :productmasterid
      t.string :variantbarcode
      t.float :price
      t.float :taxes
      t.float :total
      t.string :extproductcode
      t.text :description
      t.integer :activeid
      t.float :shipping
      
      t.timestamps
    end
  end
end
