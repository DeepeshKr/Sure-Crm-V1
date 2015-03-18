class AddProductMasterIdToOrderLine < ActiveRecord::Migration
  def change
    add_column :order_lines, :product_master_id, :integer
  end
end
