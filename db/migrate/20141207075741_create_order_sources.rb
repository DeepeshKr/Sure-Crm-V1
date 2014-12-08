class CreateOrderSources < ActiveRecord::Migration
  def change
    create_table :order_sources do |t|
      t.string :name

      t.timestamps
    end
  end
end
