class CreateReturnRates < ActiveRecord::Migration
  def change
    create_table :return_rates do |t|
      t.string :name
      t.integer :sort_order
      t.integer :total
      t.integer :cancelled
      t.integer :returned
      t.integer :paid
      t.integer :transfer_total
      t.integer :transfer_paid
      t.integer :transfer_cancelled
      t.integer :no_of_days

      t.timestamps null: false
    end
  end
end
