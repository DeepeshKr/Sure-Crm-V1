class CreateMessageStatuses < ActiveRecord::Migration
  def change
    create_table :message_statuses do |t|
      t.string :name
      t.string :description
      t.integer :sort_order

      t.timestamps null: false
    end
  end
end
