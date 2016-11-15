class CreateDispatchCallStatuses < ActiveRecord::Migration
  def change
    create_table :dispatch_call_statuses do |t|
      t.string :name
      t.text :description
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
