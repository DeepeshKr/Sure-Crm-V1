class AddCorporateIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :corporate_id, :integer
    add_column :order_masters, :order_for_id, :integer
  end
end
