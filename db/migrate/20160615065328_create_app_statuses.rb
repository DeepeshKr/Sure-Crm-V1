class CreateAppStatuses < ActiveRecord::Migration
  def change
    create_table :app_statuses do |t|
      t.string :name
      t.integer :priority_no
      t.text :description

      t.timestamps null: false
    end
  end
end
