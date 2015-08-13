class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
      t.text :description
      t.integer :start_hr
      t.integer :start_min
      t.integer :end_hr
      t.integer :end_min
      t.date :start_date
      t.date :end_date
      t.integer :media_id
      t.integer :min_sale_value
      t.decimal :discount_percent, precision: 4, scale: 4
      t.integer :discount_value
      t.integer :free_product_list_id
      t.integer :active
      t.string :unique_code
      t.decimal :promo_cost, precision: 12, scale: 2

      t.timestamps null: false
    end
  end
end
