class CreateHelpFiles < ActiveRecord::Migration
  def change
    create_table :help_files do |t|
      t.string :name
      t.string :link
      t.text :description
      t.text :code_used
      t.text :database_used
      t.string :tags
      t.integer :employee_id

      t.timestamps null: false
    end
  end
end
