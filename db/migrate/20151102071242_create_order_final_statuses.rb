class CreateOrderFinalStatuses < ActiveRecord::Migration
  def change
    create_table :order_final_statuses do |t|
      t.string :name
      t.integer :sort_order
      t.text :description

      t.timestamps null: false
    end
  end
end
