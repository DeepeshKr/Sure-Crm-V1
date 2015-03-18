class AddActiveStatusToProductList < ActiveRecord::Migration
  def change
    add_column :product_lists, :active_status_id, :integer
     add_column :product_lists, :name, :string
  end
end
