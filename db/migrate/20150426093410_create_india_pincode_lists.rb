class CreateIndiaPincodeLists < ActiveRecord::Migration
  def change
    create_table :india_pincode_lists do |t|
      t.string :officename
      t.string :pincode
      t.string :deliverystatus
      t.string :divisionname
      t.string :regionname
      t.string :circlename
      t.string :taluk
      t.string :districtname
      t.string :statename

      t.timestamps null: false
    end
  end
end
