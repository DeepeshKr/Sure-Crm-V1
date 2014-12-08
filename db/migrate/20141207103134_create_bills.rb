class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :billno
      t.date :fordate
      t.integer :orderid
      t.string :fy

      t.timestamps
    end
  end
end
