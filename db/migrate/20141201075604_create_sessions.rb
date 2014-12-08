class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :employee_code
      t.string :emailid
      t.string :userip
      t.string :sessionid

      t.timestamps
    end
  end
end
