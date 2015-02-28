class CreateProductSellTypes < ActiveRecord::Migration
  def change
    create_table :product_sell_types do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
