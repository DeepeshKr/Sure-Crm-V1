class AddImageToAppFeatureRequest < ActiveRecord::Migration
  def change
    add_column :app_feature_requests, :user_image, :string
  end
end
