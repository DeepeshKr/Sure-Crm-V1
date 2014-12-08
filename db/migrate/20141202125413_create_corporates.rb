class CreateCorporates < ActiveRecord::Migration
  def change
    create_table :corporates do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :landmark
      t.string :city
      t.string :pincode
      t.string :state
      t.string :district
      t.string :country
      t.string :telephone1
      t.string :telephone2
      t.string :fax
      t.string :website
      t.string :salute1
      t.string :first_name1
      t.string :last_name1
      t.string :designation1
      t.string :mobile1
      t.string :emaild1
      t.string :salute2
      t.string :first_name2
      t.string :last_name2
      t.string :designation2
      t.string :mobile2
      t.string :emailid2
      t.string :salute3
      t.string :first_name3
      t.string :last_name3
      t.string :designation3
      t.string :mobile3
      t.string :emailid3
      t.text :description

      t.timestamps
    end
  end
end
