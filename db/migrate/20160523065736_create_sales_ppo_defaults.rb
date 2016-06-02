class CreateSalesPpoDefaults < ActiveRecord::Migration
  def change
    create_table :sales_ppo_defaults do |t|
      t.string :name
      t.decimal :value, precision: 5, scale: 2
      t.text :description

      t.timestamps null: false
    end
  end
end
