class CreateAppFeatureComments < ActiveRecord::Migration
  def change
    create_table :app_feature_comments do |t|
      t.text :details
      t.integer :app_feature_request_id
      t.integer :comments_by_id
      t.integer :comment_type_id
      t.integer :display_level_id

      t.timestamps null: false
    end
  end
end
