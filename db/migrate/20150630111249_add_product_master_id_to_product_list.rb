class AddProductMasterIdToProductList < ActiveRecord::Migration
  def change
    add_column :product_lists, :product_master_id, :integer
  end
end
