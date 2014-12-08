class CreateOrderStatusMasters < ActiveRecord::Migration
  def change
    create_table :order_status_masters do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
