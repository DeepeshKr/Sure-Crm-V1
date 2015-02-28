class Orderpaymentmode < ActiveRecord::Base
   has_many :order_master,  foreign_key: "orderpaymentmode_id"
end
