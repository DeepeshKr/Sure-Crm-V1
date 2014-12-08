class CreateEmployees < ActiveRecord::Migration
  
  def change
    create_table :employees do |t|
      t.references :manager
      t.timestamps
    end
  end
  
  def change
    create_table :employees do |t|
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :employeecode
      t.string :designation
      t.string :mobile
      t.string :emailid
      t.string :location
      t.integer :employment_type_id
      t.integer :employee_role_id
      t.integer :reporting_to_id
      t.boolean :enablelogin
      t.text :description

      t.timestamps
    end
  end
end
