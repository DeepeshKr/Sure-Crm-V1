class CreatePayumoneyStatuses < ActiveRecord::Migration
  def change
    create_table :payumoney_statuses do |t|
      t.string :name
      t.integer :priority_no
      t.string :external_description
      t.string :valid_payment
      t.text :description

      t.timestamps null: false
    end
  end
end
