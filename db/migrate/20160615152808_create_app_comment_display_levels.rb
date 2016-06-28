class CreateAppCommentDisplayLevels < ActiveRecord::Migration
  def change
    create_table :app_comment_display_levels do |t|
      t.string :name
      t.integer :priority_no
      t.text :description

      t.timestamps null: false
    end
  end
end
