class AddIndexToProductMasterOnExtproductcode < ActiveRecord::Migration
  def change
    add_index :product_masters, :extproductcode
  end
end
