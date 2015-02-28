class CreateChangeLogTypes < ActiveRecord::Migration
  def change
    create_table :change_log_types do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
