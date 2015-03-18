class CreateProductSpecLists < ActiveRecord::Migration
  def change
    create_table :product_spec_lists do |t|
      t.string :name
      t.string :spec_1
      t.string :spec_2
      t.string :spec_3
      t.string :spec_4
      t.string :spec_5
      t.text :description

      t.timestamps null: false
    end
  end
end
