class OrderSource < ActiveRecord::Base
  has_many :order_master
end
