class MessageStatus < ActiveRecord::Base
	has_many :message_on_order, foreign_key: "message_status_id"
end
