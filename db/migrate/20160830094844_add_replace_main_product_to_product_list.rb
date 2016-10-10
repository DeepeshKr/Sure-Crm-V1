class AddReplaceMainProductToProductList < ActiveRecord::Migration
  def change
    add_column :product_lists, :replace_main_product, :boolean
  end
end
