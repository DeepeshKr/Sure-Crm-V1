class CreateCustomerCreditCards < ActiveRecord::Migration
  def change
    create_table :customer_credit_cards do |t|
      t.integer :customer_id
      t.string :card_no
      t.string :name_on_card
      t.string :expiry_mon
      t.string :expiry_yr_string

      t.timestamps null: false
    end
  end
end
