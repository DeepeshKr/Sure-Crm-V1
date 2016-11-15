class CreateOrderDispatchStatuses < ActiveRecord::Migration
  def change
    create_table :order_dispatch_statuses do |t|
      t.string :name
      t.text :description
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
