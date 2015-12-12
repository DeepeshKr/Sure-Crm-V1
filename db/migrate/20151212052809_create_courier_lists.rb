class CreateCourierLists < ActiveRecord::Migration
  def change
    create_table :courier_lists do |t|
      t.string :name
      t.text :description
      t.text :contact_details
      t.string :tracking_url
      t.string :helpline
      t.integer :sort_order
      t.string :ref_code
      t.integer :active

      t.timestamps null: false
    end
  end
end
