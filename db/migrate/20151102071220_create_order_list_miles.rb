class CreateOrderListMiles < ActiveRecord::Migration
  def change
    create_table :order_list_miles do |t|
      t.string :name
      t.integer :sort_order
      t.text :description

      t.timestamps null: false
    end
  end
end
