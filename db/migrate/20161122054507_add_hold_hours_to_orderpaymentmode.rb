class AddHoldHoursToOrderpaymentmode < ActiveRecord::Migration
  def change
    add_column :orderpaymentmodes, :hold_hours, :integer
  end
end
