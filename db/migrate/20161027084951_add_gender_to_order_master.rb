class AddGenderToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :gender, :string
    add_index :order_masters, :gender
  end
end
