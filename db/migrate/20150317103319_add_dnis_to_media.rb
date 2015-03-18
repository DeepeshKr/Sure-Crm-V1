class AddDnisToMedia < ActiveRecord::Migration
  def change
  	add_column :media, :dnis, :string
    add_column :media, :channel, :string
    add_column :media, :slot, :string

  end
end
