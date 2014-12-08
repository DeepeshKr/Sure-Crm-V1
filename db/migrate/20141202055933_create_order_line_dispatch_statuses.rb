class CreateOrderLineDispatchStatuses < ActiveRecord::Migration
  def change
    create_table :order_line_dispatch_statuses do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
