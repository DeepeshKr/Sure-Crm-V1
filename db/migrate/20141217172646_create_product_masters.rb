class CreateProductMasters < ActiveRecord::Migration
  def change
    create_table :product_masters do |t|
      t.string :name
      t.integer :productcategoryid
      t.integer :productinventorycodeid
      t.string :barcode
      t.float :price
      t.float :taxes
      t.float :total
      t.string :extproductcode
      t.text :description
      t.integer :productactivecodeid
      t.float :costprice
      t.float :costtaxes
      t.float :costtotal
      t.timestamps
    end
  end
end
