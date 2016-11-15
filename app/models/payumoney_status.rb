class PayumoneyStatus < ActiveRecord::Base
  has_many :payumoney_detail, foreign_key: "payumoney_status_id"
  has_many :pending_order, foreign_key: "pay_u_status_id"
end
