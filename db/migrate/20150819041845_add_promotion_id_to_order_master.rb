class AddPromotionIdToOrderMaster < ActiveRecord::Migration
  def change
    add_column :order_masters, :promotion_id, :integer
  end
end
