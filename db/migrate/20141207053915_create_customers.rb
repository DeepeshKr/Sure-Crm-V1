class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :salute
      t.string :first_name
      t.string :last_name
      t.string :mobile
      t.string :alt_mobile
      t.string :emailid
      t.string :alt_emailid
      t.text :description

      t.timestamps
    end
  end
end
