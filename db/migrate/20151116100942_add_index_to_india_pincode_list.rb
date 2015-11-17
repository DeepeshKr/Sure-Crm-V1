class AddIndexToIndiaPincodeList < ActiveRecord::Migration
  def change
    add_index :india_pincode_lists, :pincode
  end
end
