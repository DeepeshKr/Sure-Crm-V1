class AddControllerActionToHelpFile < ActiveRecord::Migration
  def change
    add_column :help_files, :domain, :string
    add_column :help_files, :controller, :string
    add_column :help_files, :action, :string
    add_column :help_files, :screen_shot, :string
    add_column :help_files, :parameters, :text
    
    add_index :help_files, :link
    add_index :help_files, :controller
    add_index :help_files, :action
    add_index :help_files, :tags
  end
end
