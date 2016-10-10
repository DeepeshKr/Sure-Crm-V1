class AddTalukIndexToIndiaPincodeList < ActiveRecord::Migration
  def change
    add_index :india_pincode_lists, :taluk
    add_index :india_pincode_lists, :districtname
    add_index :india_pincode_lists, :statename
    add_index :india_pincode_lists, :officename
    add_index :india_pincode_lists, :circlename
    add_index :india_pincode_lists, :regionname
    add_index :india_pincode_lists, :divisionname
  end
end
