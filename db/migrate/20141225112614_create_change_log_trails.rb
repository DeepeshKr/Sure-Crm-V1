class CreateChangeLogTrails < ActiveRecord::Migration
  def change
    create_table :change_log_trails do |t|
      t.integer :changelogtype_id
      t.integer :refid
      t.string :name
      t.text :description
      t.string :username
      t.string :ip

      t.timestamps
    end
  end
end
