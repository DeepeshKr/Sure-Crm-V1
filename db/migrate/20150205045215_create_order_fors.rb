class CreateOrderFors < ActiveRecord::Migration
  def change
    create_table :order_fors do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
