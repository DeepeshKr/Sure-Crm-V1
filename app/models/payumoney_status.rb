class PayumoneyStatus < ActiveRecord::Base
  has_many :payumoney_detail, foreign_key: "payumoney_status_id"
end
