class AddOffsetToReturnRate < ActiveRecord::Migration
  def change
    add_column :return_rates, :offset, :integer
    add_column :return_rates, :media_id, :integer
    add_column :return_rates, :product_master_id, :integer
    add_column :return_rates, :product_variant_id, :integer
    add_column :return_rates, :product_list_id, :integer
    add_column :return_rates, :ext_prod_code, :string
    
    add_index :return_rates, :ext_prod_code
    add_index :return_rates, :product_list_id
    add_index :return_rates, :product_variant_id
    add_index :return_rates, :product_master_id
    add_index :return_rates, :media_id
    add_index :return_rates, :offset
  end
end
