class AddChargesToOrderpaymentmode < ActiveRecord::Migration
  def change
    add_column :orderpaymentmodes, :charges, :float
  end
end
