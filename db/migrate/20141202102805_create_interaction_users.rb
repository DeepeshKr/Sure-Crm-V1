class CreateInteractionUsers < ActiveRecord::Migration
  def change
    create_table :interaction_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
