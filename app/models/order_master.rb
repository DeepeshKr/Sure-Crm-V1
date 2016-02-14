class OrderMaster < ActiveRecord::Base
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  belongs_to :employee, foreign_key: "employee_id"
  belongs_to :order_source
  belongs_to :order_status_master, foreign_key: "order_status_master_id" #, polymorphic: true
  belongs_to :order_source
  belongs_to :orderpaymentmode,  foreign_key: "orderpaymentmode_id"
  belongs_to :customer, foreign_key: "customer_id" #, polymorphic: true
  belongs_to :customer_address, foreign_key: "customer_address_id" #, polymorphic: true
  belongs_to :medium, foreign_key: "media_id"
  belongs_to :promotion, foreign_key: "promotion_id"
  belongs_to :order_final_status, foreign_key: "order_final_status_id"
  belongs_to :order_last_mile, foreign_key: "order_last_mile_id"

  has_many :interaction_master, foreign_key: "orderid"
  has_many :page_trail, foreign_key: "order_id"
  has_many :order_line, foreign_key: "orderid", :dependent => :destroy

  accepts_nested_attributes_for :order_line,  :allow_destroy => true

  validates_presence_of :calledno , :mobile

  validates_associated :order_line

  #external order
  #order_for_id - Integer update with customer order id
  #external_order_no - string update with customer order id


  def fullname
      self.customer.fullname if self.customer.present?
  end
  def customer_city
    return self.customer_address.city  if self.customer_address.present?
  end
  def employee_name
    return self.employee.fullname  if self.employee.present?
  end
  def lastvisitpage
    return self.page_trail.name  if self.page_trail.present?
  end

#after_create :on_create

#after_save :on_upate

#after_update :on_update
#external order
#order_for_id - Integer update with customer order id
#external_order_no - string update with customer order id
def neworder(source, cli, dnis,empcode, empid,request_ip, session_id)

  order_master = OrderMaster.create!(calledno: dnis, order_status_master_id: 10000,
    orderdate: Time.zone.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0,
    shipping:0, total: 0, order_source_id: source.to_i, employeecode: empcode,
    employee_id: empid, userip: request_ip, sessionid: session_id,
    order_for_id: 10000, mobile: cli, notes: " ", g_total: 0)

  return order_master
end

def duplicate_order(old_order_id)
  old_order_master = OrderMaster.find(old_order_id)

  new_order_master = OrderMaster.create!(calledno: old_order_master.calledno,
    order_status_master_id: 10000,
    orderdate: old_order_master.orderdate,
    customer_id: old_order_master.customer_id,
    customer_address_id: old_order_master.customer_address_id,
    pieces: 0,subtotal: 0,
    taxes: 0, codcharges: 0, shipping:0,
    orderpaymentmode_id:  old_order_master.orderpaymentmode_id,
    total: 0, order_source_id: old_order_master.order_source_id,
    campaign_playlist_id: old_order_master.campaign_playlist_id,
    media_id: old_order_master.media_id,
    employeecode: old_order_master.employeecode,
    employee_id: old_order_master.employee_id,
    userip: request.remote_ip, sessionid: session.id,
    order_for_id: 10000, mobile: old_order_master.mobile,
    original_order_id: old_order_id,
    city: old_order_master.city, pincode: old_order_master.pincode,
    g_total: 0 ,
    notes: old_order_master.notes + " Duplicated Order for #{old_order_id}")


  old_order_master.update(original_order_id: old_order_id)

  return new_order_master.id
end

def update_customer_order_list(order_id)
    creditcardno =  nil
    expmonth = nil
    expyear = nil
    name_on_card = nil
    cardname = nil

    #order_id = @order_master.id
    pro_order_master = OrderMaster.find(order_id)

    gra_total = pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra + pro_order_master.creditcardcharges + pro_order_master.maharastraccextra

    pro_order_master.update(g_total: gra_total)

    t = Time.zone.now + 330.minutes
        nowhour = t.strftime('%H').to_i
        #=> returns a 0-padded string of the hour, like "07"
        nowminute = t.strftime('%M').to_i

     creditcardcharges = ''

    if pro_order_master.orderpaymentmode_id == 10000
      customer_credit_card = CustomerCreditCard.where(customer_id: pro_order_master.customer_id).last
      creditcardno =  customer_credit_card.card_no.truncate(20)
      expmonth = customer_credit_card.expiry_mon.truncate(2).rjust(2, '0')
      expyear = customer_credit_card.expiry_yr_string.truncate(4).rjust(4, '0')[-2..-1]
      cardtype = CreditCard.find_type(creditcardno).truncate(20)
      creditcardcharges = "Y"
    end
    if pro_order_master.orderpaymentmode_id == 10060
      creditcardno =  "4111111111111111"
      expmonth = (Time.zone.now + 330.minutes).month
      expyear = (Time.zone.now + 330.minutes).year
      cardtype = "Atom CC"
      creditcardcharges = "Y"
    end

    if pro_order_master.external_order_no.nil?
       qty1 = 0
       qty2 = 0
       qty3 = 0
       qty4 = 0
       qty5 = 0
       qty6 = 0
       qty7 = 0
       qty8 = 0
       qty9 = 0
       qty10 = 0
       prod1 = ""
       prod2 = ""
       prod3 = ""
       prod4 = ""
       prod5 = ""
       prod6 = ""
       prod7 = ""
       prod8 = ""
       prod9 = ""
       prod10 = ""

       orderline1 = OrderLine.where("orderid = ?", order_id).order("id")
        if orderline1.present?
          qty1 = orderline1.first.pieces.to_i
          prod1 = orderline1.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(qty1: qty1, prod1: prod1)
        end

        orderline2 = OrderLine.where("orderid = ?", order_id).order("id").offset(1)
        if orderline2.present?
          qty2 = orderline2.first.pieces.to_i
          prod2 = orderline2.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod2: prod2, qty2: qty2)
        end
        orderline3 = OrderLine.where("orderid = ?", order_id).order("id").offset(2)
        if orderline3.present?
          qty3 = orderline3.first.pieces.to_i
          prod3 = orderline3.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod3: orderline3.first.product_list.extproductcode.truncate(10).upcase, qty3: orderline3.first.pieces.to_i)
        end
        orderline4 = OrderLine.where("orderid = ?", order_id).order("id").offset(3)
        if orderline4.present?
          qty4 = orderline4.first.pieces.to_i
          prod4 = orderline4.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod4: orderline4.first.product_list.extproductcode.truncate(10).upcase, qty4: orderline4.first.pieces.to_i)
        end
        orderline5 = OrderLine.where("orderid = ?", order_id).offset(4)
        if orderline5.present?
          qty5 = orderline5.first.pieces.to_i
          prod5 = orderline5.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod5: orderline5.first.product_list.extproductcode.truncate(10).upcase, qty5: orderline5.first.pieces.to_i)
        end
        orderline6 = OrderLine.where("orderid = ?", order_id).offset(5)
        if orderline6.present?
          qty6 = orderline6.first.pieces.to_i
          prod6 = orderline6.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod6: orderline6.first.product_list.extproductcode.truncate(10).upcase, qty6: orderline6.first.pieces.to_i)
        end
        orderline7 = OrderLine.where("orderid = ?", order_id).offset(6)
        if orderline7.present?
          qty7 = orderline7.first.pieces.to_i
          prod7 = orderline7.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod7: orderline7.first.product_list.extproductcode.truncate(10).upcase, qty7: orderline7.first.pieces.to_i)
        end
        orderline8 = OrderLine.where("orderid = ?", order_id).offset(7)
        if orderline8.present?
          qty8 = orderline8.first.pieces.to_i
          prod8 = orderline8.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod8: orderline8.first.product_list.extproductcode.truncate(10).upcase, qty8: orderline8.first.pieces.to_i)
        end
        orderline9 = OrderLine.where("orderid = ?", order_id).offset(8)
        if orderline9.present?
          qty9 = orderline9.first.pieces.to_i
          prod9 = orderline9.first.product_list.extproductcode[0..9].upcase
          #customer_order_list.update(prod9: orderline9.first.product_list.extproductcode.truncate(10).upcase, qty9: orderline9.first.pieces.to_i)
        end
        orderline10 = OrderLine.where("orderid = ?", order_id).offset(9)
        # if orderline10.exists?
        #   customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
        # end
        if pro_order_master.customer_address.st.upcase == "MAH"
           qty10 = 1
          prod10 = "2.5"
        end

        #establish_connection "#{Rails.env}_cccrm"
         if Rails.env == "development"
            ActiveRecord::Base.establish_connection :development_cccrm
         elsif Rails.env == "production"
            ActiveRecord::Base.establish_connection :production_cccrm
         end

        #ActiveRecord::Base.establish_connection("#{Rails.env}_cccrm")
        hash =  ActiveRecord::Base.connection.exec_query("select ordernumc.nextval from dual")[0]
        #order_num =  hash["nextval"]

        if Rails.env == "development"
          ActiveRecord::Base.establish_connection :development_testora
        elsif Rails.env == "production"
          ActiveRecord::Base.establish_connection :production_testora
        end
        #ActiveRecord::Base.establish_connection("#{Rails.env}_testora")

        #hash = ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0]

        order_num =  hash["nextval"]

        #flash[:notice] = "Order Number is #{order_num}"
             #CustomerOrderList Date.current Date.today.in_time_zone Time.zone.now
        customer_order_list = CustomerOrderList.create(ordernum: order_num,
        orderdate: (330.minutes).from_now.to_date,
        title: pro_order_master.customer.salute[0..4].upcase,
        fname: pro_order_master.customer.first_name[0..29].upcase,
        lname: pro_order_master.customer.last_name[0..29].upcase,
        add1: pro_order_master.customer_address.address1[0..29].upcase,
        add2: pro_order_master.customer_address.address2[0..29].upcase,
        add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
        landmark: pro_order_master.customer_address.landmark[0..49].upcase,
        city: pro_order_master.customer_address.city[0..29].upcase,
        state: pro_order_master.customer_address.st[0..4].upcase,
        pincode: pro_order_master.customer_address.pincode,
        mstate: pro_order_master.customer_address.state[0..49].upcase,
        tel1: pro_order_master.customer.mobile[0..19].upcase,
        tel2: (pro_order_master.customer_address.telephone2[0..19].upcase if pro_order_master.customer_address.telephone2.present?),
        fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
        email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
        ccnumber:  creditcardno,
        expmonth:  expmonth,
        expyear:  expyear,
        cardtype: cardtype,
        carddisc: creditcardcharges,
        ipadd: (pro_order_master.userip[0..49] if pro_order_master.userip.present?),
        dnis: pro_order_master.calledno,
        channel: pro_order_master.medium.name.strip[0..48].upcase,
        chqdisc: pro_order_master.creditcardcharges,
        totalamt: pro_order_master.g_total,
        trandate: Time.zone.now,
        username: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
        oper_no: pro_order_master.employeecode,
        dt_hour: nowhour,
        dt_min: nowminute,
        uae_status: pro_order_master.customer.gender[0..49].upcase,
        prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
        qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)

        #CUSTDETAILS
        customerdetails = CUSTDETAILS.create(ordernum: order_num,
        transfer_ok: 0,
        orderdate: (330.minutes).from_now.to_date,
        title: pro_order_master.customer.salute[0..4].upcase,
        fname: pro_order_master.customer.first_name[0..29].upcase,
        lname: pro_order_master.customer.last_name[0..29].upcase,
        add1: pro_order_master.customer_address.address1[0..29].upcase,
        add2: pro_order_master.customer_address.address2[0..29].upcase,
        add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
        landmark: pro_order_master.customer_address.landmark[0..49].upcase,
        city: pro_order_master.customer_address.city[0..29].upcase,
        state: pro_order_master.customer_address.st[0..4].upcase,
        pincode: pro_order_master.customer_address.pincode,
        mstate: pro_order_master.customer_address.state[0..49].upcase,
        tel1: pro_order_master.customer.mobile[0..19].upcase,
        tel2: (pro_order_master.customer_address.telephone2[0..17].upcase if pro_order_master.customer_address.telephone2.present?),
        fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
        email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
        ccnumber:  creditcardno,
        expmonth:  expmonth,
        expyear:  expyear,
        cardtype: cardtype,
        carddisc: creditcardcharges,
        ipadd: (pro_order_master.userip[0..49] if pro_order_master.userip.present?),
        dnis: pro_order_master.calledno,
        channel: pro_order_master.medium.name.strip[0..48].upcase,
        chqdisc: pro_order_master.creditcardcharges,
        totalamt: pro_order_master.g_total,
        trandate: Time.zone.now,
        username: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
        oper_no: pro_order_master.employeecode,
        dt_hour: nowhour,
        dt_min: nowminute,
        uae_status: pro_order_master.customer.gender[0..49].upcase,
        prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
        qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)


        #- Integer update with customer order id
        pro_order_master.update(external_order_no: order_num.to_s, order_status_master_id: 10003)

      return order_num.to_s #customer_order_list.ordernum
    end

  end
after_destroy :updateOrder

  def no_order_master(attributes)
  attributes[:id].blank?
  end

  def timetaken
    ended_on = self.updated_at.to_f
    started_at = self.created_at.to_f
    return (ended_on - started_at).to_i
  end

  def promo_cost
   #self.promotion
  end

  def codcharges
  productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.codcharges || 0
    end
    return total.round(2)

  else
    return 0
  end

end

def creditcardcharges
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.creditcardcharges || 0
    end
    return total.round(2)

  else
    return 0
  end

end

def maharastracodextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastracodextra || 0

    end
    return total.round(2)

  else
    return 0
  end

end

def servicetax
  productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.servicetax || 0

    end
    return total.round(2)

  else
    return 0
  end

end

def maharastraccextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastraccextra || 0

    end
    return total.round(2)

  else
    return 0
  end

end
# 10060 Based on Shipment
# 10020 Based on Orders Generated All orders less estimated cancel rate is used to calculate the commission
# 10021 Based on Paid Order Commission is paid only on all fully paid orders
# 10041 Daily Fixed and Percent on Shipped Orders Daily Fixed and Percent on Shipped Orders for cable TV operators
# 10000 Airtime Purchased Airtime is purchased from the media / operator
# 10040 Daily Fixed and Percent on Paid Orders  For cable TV operators based on fixed daily and Paid Orders
# 10045 Fixed Daily Charges   Only fixed daily charges
def mediacost
    if self.media_id.present?
     media_variable = Medium.where('id = ? AND value is not null', self.media_id)
      .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
      if media_variable.present?
        #discount the total value by 50% as correction
        correction = 0.5
        #PAID_CORRECTION
         if media_variable.first.paid_correction.present?
            correction = media_variable.first.paid_correction #||= 0.5
         end
         #value is the amout to be paid to distributr
          return (((self.subtotal) * 0.888889) * media_variable.first.value.to_f) * correction
      end
  else
    return 0
  end
end

def media_commission
   media_variable = Medium.where('id = ? AND value is not null', self.media_id)
    .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
     if media_variable.present?
         #discount the total value by 50% as media_correction
       media_correction = 0.5
       #PAID_CORRECTION
        if media_variable.first.paid_correction.present?
         media_correction = media_variable.first.paid_correction #||= 0.5
        end
        return ((self.subtotal * 0.888889) * media_variable.first.value.to_f) #* media_correction
      else
        return 0
      end
end
def mediacomission
    if self.media_id.present?
     media_variable = Medium.where('id = ? AND value is not null', self.media_id)
      .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
      if media_variable.present?
        #discount the total value by 50% as correction
        correction = 0.5
        #PAID_CORRECTION
         if media_variable.first.paid_correction.present?
            correction = media_variable.first.paid_correction #||= 0.5
         end
         #value is the amout to be paid to distributr
          return (((self.subtotal) * 0.888889) * media_variable.first.value.to_f) * correction
      end
  else
    return 0
  end
end

def productcost
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      if c.total > 0
        total += c.productcost
      end
    end
    return total

  else
    return 0
  end

end
def productrevenue
   totalrevenue = 0
    totalrevenue += ((self.subtotal) * 0.888889)|| 0
    totalrevenue += ((self.shipping) * 0.98125)|| 0
     return totalrevenue
end

def grand_total

return self.subtotal + self.shipping + self.codcharges + self.servicetax + self.maharastracodextra + self.creditcardcharges + self.maharastraccextra

end

private
  def on_create
  #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
  end

   def on_update
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))

  end

   def on_destroy
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
  #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  end

end
