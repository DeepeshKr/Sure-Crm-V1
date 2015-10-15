class AddCodOptionsToProductMaster < ActiveRecord::Migration
  def change
    add_column :product_masters, :sel_cod, :integer
    add_column :product_masters, :sel_s_tax, :integer
    add_column :product_masters, :sel_m_cod, :integer
    add_column :product_masters, :sel_m_cc, :integer
    add_column :product_masters, :sel_cc, :integer
  end
end
