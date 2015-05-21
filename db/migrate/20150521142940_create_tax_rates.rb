class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.decimal :value
      t.decimal :reverse
      t.text :description

      t.timestamps null: false
    end
  end
end
