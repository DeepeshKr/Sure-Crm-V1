class AddSortOrderToProductMasterAddOn < ActiveRecord::Migration
  def change
    add_column :product_master_add_ons, :sort_order, :integer
    add_column :product_master_add_ons, :replace_by_product_id, :integer
  end
end
