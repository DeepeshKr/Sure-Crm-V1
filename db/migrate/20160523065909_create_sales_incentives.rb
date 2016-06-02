class CreateSalesIncentives < ActiveRecord::Migration
  def change
    create_table :sales_incentives do |t|
      t.string :name
      t.decimal :min_value, precision: 6, scale: 4
      t.decimal :max_value, precision: 6, scale: 4
      t.decimal :commission, precision: 6, scale: 4
      t.integer :no_of
      t.text :description

      t.timestamps null: false
    end
  end
end
