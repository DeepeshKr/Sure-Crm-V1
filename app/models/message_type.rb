class MessageType < ActiveRecord::Base
	has_many :message_on_order, foreign_key: "message_type_id"
end
