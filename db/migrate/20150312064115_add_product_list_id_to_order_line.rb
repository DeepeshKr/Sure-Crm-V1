class AddProductListIdToOrderLine < ActiveRecord::Migration
  def change
    add_column :order_lines, :product_list_id, :integer
  end
end
