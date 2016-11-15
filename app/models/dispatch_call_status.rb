class DispatchCallStatus < ActiveRecord::Base
   has_many :pending_order, foreign_key: "dispatch_call_status_id"
end
