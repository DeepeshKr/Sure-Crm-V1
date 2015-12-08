class MessageOnOrder < ActiveRecord::Base
	belongs_to :message_type, foreign_key: "message_type_id"
	belongs_to :message_status, foreign_key: "message_status_id"
	belongs_to :customer, foreign_key: "customer_id"

	def send_message(mobile, order_no)
			username = "Telebrands"
		  password = "Telebrands"
		  cdmaheader = "TBRAND"
		  senderid = "TBRAND"

		  require "net/http"
		  require "uri"
		  require 'open-uri'

						message = "Thanks for Order, #{order_no}, products will reach you in 7-10 days. Please pay cash on delivery  Telebrands"

						message = message[0..159]

		        weburl = "http://whitelist.smsapi.org/SendSMS.aspx?UserName=#{username}&password=#{password}&SenderID=#{senderid}&CDMAHeader=#{cdmaheader}&MobileNo=#{mobile}&Message=#{message}"

		        response = url_response(weburl)

end

		  private

		  def url_response(weburl)
		    weburl = URI::encode(weburl)
		    uri = URI.parse(weburl)
		    http = Net::HTTP.new(uri.host, uri.port)
		    request = Net::HTTP::Get.new(uri.request_uri)
		    return response = http.request(request)

		  end
end
