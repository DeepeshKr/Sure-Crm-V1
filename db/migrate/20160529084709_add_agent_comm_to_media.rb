class AddAgentCommToMedia < ActiveRecord::Migration
  def change
    add_column :media, :agent_comm, :decimal, precision: 8, scale: 4
  end
end
