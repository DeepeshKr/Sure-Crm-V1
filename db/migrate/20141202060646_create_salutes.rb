class CreateSalutes < ActiveRecord::Migration
  def change
    create_table :salutes do |t|
      t.string :name

      t.timestamps
    end
  end
end
