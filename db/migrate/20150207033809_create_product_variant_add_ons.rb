class CreateProductVariantAddOns < ActiveRecord::Migration
  def change
    create_table :product_variant_add_ons do |t|
      t.integer :productid
      t.integer :productvariantid

      t.timestamps null: false
    end
  end
end
