class AddEcsLimitToOrderPayment < ActiveRecord::Migration
  def change
    add_column :order_payments, :ecs_limit, :decimal
    add_index :order_payments, :ecs_limit
  end
end
