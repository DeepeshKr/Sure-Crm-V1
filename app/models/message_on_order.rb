class MessageOnOrder < ActiveRecord::Base
	belongs_to :message_type, foreign_key: "message_type_id"
	belongs_to :message_status, foreign_key: "message_status_id"
	belongs_to :customer, foreign_key: "customer_id"
	
end
