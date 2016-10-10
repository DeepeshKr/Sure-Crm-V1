class AddImageToAppFeatureComment < ActiveRecord::Migration
  def change
    add_column :app_feature_comments, :user_image, :string
  end
end
