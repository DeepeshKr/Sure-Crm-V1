class CreateListOfServers < ActiveRecord::Migration
  def change
    create_table :list_of_servers do |t|
      t.string :name
      t.text :description
      t.datetime :active_since
      t.string :internal_ip
      t.string :vpn_ip
      t.string :external_ip
      t.string :current_status

      t.timestamps null: false
    end
  end
end
