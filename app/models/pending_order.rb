class PendingOrder < ActiveRecord::Base
  validates :order_ref_id, uniqueness: { message: "Order Ref Id has been used" }
  validates :order_no, uniqueness: { message: "Order No has been used" }
  validates_presence_of :cod_amount, :pay_u_amount
  
  belongs_to :order_master, foreign_key: "order_ref_id"
  
  belongs_to :order_dispatch_status, foreign_key: "order_dispatch_status_id" #
  belongs_to :courier_list, foreign_key: "courier_list_id" #
  belongs_to :payumoney_status, foreign_key: "pay_u_status_id" #
  belongs_to :dispatch_call_status, foreign_key: "dispatch_call_status_id"
 
  # validates :airway_bill,  allow_blank: true, uniqueness: { message: "Web Id card has to been used or leave it blank" }
 #  validates_presence_of :order_ref_id ,
  # params.require(:pending_order).permit(:order_ref_id, :order_no, :order_dispatch_status_id, :cod_amount, :pay_u_amount, :courier_list_id, :pay_u_status_id, :dispatch_call_status_id, :airway_bill, :pod)
  # courier_list_id 10020 => india post, 10021 => fedex 10022 => gati
  def savings
    self.cod_amount - self.pay_u_amount 
  end
  
  def self.import(file)
         
      CSV.foreach(file.path, headers: true) do |row|
    
        pending_orders_hash = row.to_hash # exclude the price field
        #help_file_lists = PendingOrder.where(link: pending_order_hash["link"])
        
        tel1_l = pending_orders_hash["TEL1"].strip if pending_orders_hash["TEL1"]
        tel2_l = pending_orders_hash["TEL2"].strip if pending_orders_hash["TEL2"]
        manifest_l = pending_orders_hash["MANIFEST"].strip if pending_orders_hash["MANIFEST"]
        despatch_l = pending_orders_hash["DESPATCH"].strip if pending_orders_hash["DESPATCH"]
        
        vpp_search = VPP.where(manifest: manifest_l) #.where(custref: @ordernum)
        if vpp_search.present?
          #redirect_to custordersearch_path(:order_id => @order_id)
          order = vpp_search.first.order_master
          # get order master details order id to create the list
          create_list order.id, tel1_l, tel2_l, manifest_l, despatch_l
        end
      end # end CSV.foreach
  end # end self.import(file)
  
  def self.create_list order_id, tel1 = nil, tel2 = nil, manifest = nil, dispatch = nil
    valid_status = [10005]  # dispatched
    # only COD orders
    order_master = OrderMaster.where(id: order_id).where(order_status_master_id: valid_status, 
    orderpaymentmode_id: 10001)
    
      if order_master.present?
      #check if found in pending order present for the order
        if PendingOrder.where(:order_ref_id => order_id).blank?
          pay_u_total = order_master.first.subtotal.to_f + order_master.first.shipping.to_f + order_master.first.creditcard_savings.to_f + order_master.first.maharastracc_savings.to_f 
      
       pending_order = PendingOrder.create(:order_ref_id => order_id, 
        :order_date => order_master.first.orderdate,
        :order_no => order_master.first.external_order_no, 
        :order_dispatch_status_id => 10000, 
        :cod_amount => order_master.first.g_total, 
        :pay_u_amount => pay_u_total, 
        :dispatch_call_status_id => 10000,
        :tel_1 => tel1,
        :tel_2 => tel2,
        :manifest => manifest,
        :courier_name => dispatch)
      
        
        # create pay by Pay U sms for customer
          # send_sms order_id, pay_u_total, order_master.first.g_total, pending_order.savings
        # create pay u money sms for customer
          # send_pay_u_sms_invoice order_id, pay_u_total
      
        
        end
      end
    
  end
    
  def self.send_pay_u_sms_invoice order_id
      this_time = Time.zone.now + 330.minutes
      current_time = Time.zone.now + 330.minutes
      order_master = OrderMaster.find(order_id)
      
      pending_order = PendingOrder.find_by_order_ref_id(order_id)
      pay_u_amount = pending_order.pay_u_amount
      pending_order.update(pay_u_status_id: 10000)
      
      transaction_ref = SecureRandom.uuid
      customerName = "#{order_master.customer.salute.upcase} #{order_master.customer.first_name.upcase} #{order_master.customer.last_name.upcase}"

      description = " order ref no #{order_id} to be paid in 2 hrs"

      if alternative_mobile.present?
        customerMobileNumber = alternative_mobile
        confirmSMSPhone = alternative_mobile
      else
        customerMobileNumber = order_master.mobile
        confirmSMSPhone = order_master.mobile
      end

      url = "https://www.payumoney.com/payment/payment/smsInvoice?"
      encoded_url = URI.encode("amount=#{pay_u_amount}&customerName=#{customerName}&description=#{description}&referenceId=#{transaction_ref}&customerMobileNumber=#{customerMobileNumber}&confirmSMSPhone=#{customerMobileNumber}")


      payumoney_detail = PayumoneyDetail.create(orderid: order_master.id,
        payumoney_status_id: 10000,
        amount: amount.to_i,
        customerMobileNumber: customerMobileNumber,
        message_url: "#{url}#{encoded_url}",
        transaction_ref: transaction_ref,
        transaction_history: "Post Dispatch Ref #{transaction_ref} created at #{this_time}")
          
        return "The customer would get an SMS for amount #{pay_u_amount} on mobile no #{customerMobileNumber} and is in queue #{payumoney_detail.id}"
  end
  
  def self.regenerate_pay_u_sms_invoice order_id
    #order_id = self.id
    this_time = Time.zone.now + 330.minutes
    current_time = Time.zone.now + 330.minutes
    order_master = OrderMaster.find(order_id)
    customerMobileNumber = order_master.mobile
    
    pending_order = PendingOrder.find_by_order_ref_id(order_id)
    pay_u_amount = pending_order.pay_u_amount
    
    transaction_ref = SecureRandom.uuid
    customerName = "#{order_master.customer.salute.upcase} #{order_master.customer.first_name.upcase} #{order_master.customer.last_name.upcase}"

    description = " new order ref no #{order_id} to be paid in 2 hrs"


    url = "https://www.payumoney.com/payment/payment/smsInvoice?"
    encoded_url = URI.encode("amount=#{pay_u_amount}&customerName=#{customerName}&description=#{description}&referenceId=#{transaction_ref}&customerMobileNumber=#{customerMobileNumber}&confirmSMSPhone=#{customerMobileNumber}")

    payumoney_detail = PayumoneyDetail.find_by_orderid(order_id)
    transaction_history = payumoney_detail.transaction_history
    payumoney_detail.update(orderid: order_id,
      payumoney_status_id: 10005,
      customerMobileNumber: customerMobileNumber,
      message_url: "#{url}#{encoded_url}",
      transaction_ref: transaction_ref,
      transaction_history: "#{transaction_history} \r\n New updated => Ref #{transaction_ref} at #{this_time}")

      return "The customer would get an SMS for amount #{amount} on mobile no #{customerMobileNumber} and is in queue #{payumoney_detail.id}"
  end
  
  def send_sms order_id, pay_u_amount, cod_amount, savings
      order_master = OrderMaster.find(order_id)
      message = "Thanks for your payment of Rs.#{order_master.grand_total.to_i.to_s} towards#{cc_order_number.join(",")} which will reach you in 7-10 days.For any queries call 9223100730 HBN/TELEBRANDS."
    

    message = message[0..159]
    sms_message = MessageOnOrder.create(customer_id: order_master.customer_id,
      message_status_id: 10000, message_type_id: 10000,
      mobile_no: order_master.customer.mobile,
      order_id: order_id,
      alt_mobile_no: order_master.customer.alt_mobile,
      message: message)

      return message
  end
 
  private
  
  
  
end
