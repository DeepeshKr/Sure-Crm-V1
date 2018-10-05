class AddTaxIdToProductMaster < ActiveRecord::Migration
  def change
     add_column :product_masters, :tax_id, :integer
  end
end
