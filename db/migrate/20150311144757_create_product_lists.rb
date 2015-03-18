class CreateProductLists < ActiveRecord::Migration
  def change
    create_table :product_lists do |t|
      t.integer :product_variant_id
      t.integer :product_spec_list_id
      t.string :extproductcode
      t.string :list_barcode

      t.timestamps null: false
    end
  end
end
