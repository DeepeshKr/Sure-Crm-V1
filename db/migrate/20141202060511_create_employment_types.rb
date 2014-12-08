class CreateEmploymentTypes < ActiveRecord::Migration
  def change
    create_table :employment_types do |t|
      t.string :name
      t.integer :sortorder

      t.timestamps
    end
  end
end
