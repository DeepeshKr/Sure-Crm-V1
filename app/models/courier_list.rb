class CourierList < ActiveRecord::Base
   has_many :pending_order, foreign_key: "courier_list_id"
end
