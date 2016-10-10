class CustomerOrderList < ActiveRecord::Base
#  self.sequence_name = 'order_seq'
 belongs_to :order_master, foreign_key: "order_id"
# before_create do
#     #since we can't use the normal set sequence name we have to set the primary key manually
#     #so the execute command return an array of hashes,
#     #so we grab the first one and get the nextval column from it and set it on id
#    self.ordernum = ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0]
# end

# def get_sequence_id
#        # self.find_by_sql "select order_seq.nextval as order_num from dual"
#       return  ActiveRecord::Base.connection.exec_query("select order_seq.nextval as order_num from dual").fetch
#     end

#  def next
#  	return ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0] 
#  	#CUSTOMER_ORDER_LISTS_SEQ
#  end
  def custdetails
    return "Not found in CUSTDETAILS" if CUSTDETAILS.find_by_ordernum(self.ordernum).blank?
    custdetail = CUSTDETAILS.find_by_ordernum(self.ordernum).orderdate.strftime("%d-%b-%Y")
    return "Found in CUSTDETAIL dated: #{custdetail}"
  end
  
  def vpp
    return "Not found in VPP" if VPP.find_by_custref(self.ordernum).blank?
    vpp = VPP.find_by_custref(self.ordernum).orderdate.strftime("%d-%b-%Y")
    return "Found in VPP dated: #{vpp}"
  end
  
  def dealtran
    return "Not found in DEALTRAN" if DEALTRAN.find_by_custref(self.ordernum).blank?
    dealtran = DEALTRAN.find_by_custref(self.ordernum).orderdate.strftime("%d-%b-%Y")
    return "Found in DEALTRAN dated: #{dealtran}"
  end 
  
  def order_ref
    OrderMaster.find_by_external_order_no(self.ordernum).id
  end
  
  def testora_user
    OrderMaster.find_by_external_order_no(self.ordernum).employee.first_name
  end
  
  def custdetails_user
    CUSTDETAILS.where("UPPER(username) like ?", "%#{self.username}%").first.username
    #CUSTDETAILS.find_by_ordernum(self.ordernum).username
  end
  
  def regenerate_customer_order_list
    
    #check if already added, then update else add
    if CUSTDETAILS.where(ordernum: order_num).present?
      cust_detail = CUSTDETAILS.find(order_num)
      cust_detail.update(transfer_ok: 0,
      orderdate: self.orderdate,
      title: self.title,
      fname: self.fname,
      lname: self.lname,
      add1: self.add1,
      add2: self.add2,
      add3: self.add3,
      landmark: self.landmark,
      city: self.city,
      state: self.state,
      pincode: self.state,
      mstate: self.mstate,
      tel1: self.tel1,
      tel2: self.tel2,
      fax: self.fax,
      email: self.customer.emailid,
      ccnumber: self.creditcardno,
      expmonth: self.expmonth,
      expyear: self.expyear,
      cardtype: self.cardtype,
      carddisc: self.creditcardcharges,
      ipadd: self.userip,
      dnis: self.calledno,
      channel: self.medium.name,
      chqdisc: self.creditcardcharges,
      totalamt: self.g_total,
      trandate: (Time.zone.now + 330.minutes), 
      username: self.employee,
      oper_no: self.employeecode,
      dt_hour: self.nowhour,
      dt_min: self.nowminute,
      in_date: self.in_date,
      uae_status: self.customer.gender,
      prod1: self.prod1, prod2: self.prod2, prod3: self.prod3, prod4: self.prod4, prod5: self.prod5, prod6: self.prod6,
      prod7: self.prod7, prod8: self.prod8, prod9: self.prod9, prod10: self.prod10,
      qty1: self.qty1, qty2: self.qty2, qty3: self.qty3, qty4: self.qty4, qty5: self.qty5, qty6: self.qty6, 
      qty7: self.qty7, qty8: self.qty8, qty9: self.qty9, qty10: self.qty10)

    else

      customerdetails = CUSTDETAILS.create(ordernum: self.order_num,
        transfer_ok: 0,
        orderdate: self.orderdate,
        title: self.title,
        fname: self.fname,
        lname: self.lname,
        add1: self.add1,
        add2: self.add2,
        add3: self.add3,
        landmark: self.landmark,
        city: self.city,
        state: self.state,
        pincode: self.state,
        mstate: self.mstate,
        tel1: self.tel1,
        tel2: self.tel2,
        fax: self.fax,
        email: self.customer.emailid,
        ccnumber: self.creditcardno,
        expmonth: self.expmonth,
        expyear: self.expyear,
        cardtype: self.cardtype,
        carddisc: self.creditcardcharges,
        ipadd: self.userip,
        dnis: self.calledno,
        channel: self.medium.name,
        chqdisc: self.creditcardcharges,
        totalamt: self.g_total,
        trandate: (Time.zone.now + 330.minutes), 
        username: self.employee,
        oper_no: self.employeecode,
        dt_hour: self.nowhour,
        dt_min: self.nowminute,
        in_date: self.in_date,
        uae_status: self.customer.gender,
        prod1: self.prod1, prod2: self.prod2, prod3: self.prod3, prod4: self.prod4, prod5: self.prod5, prod6: self.prod6,
        prod7: self.prod7, prod8: self.prod8, prod9: self.prod9, prod10: self.prod10,
        qty1: self.qty1, qty2: self.qty2, qty3: self.qty3, qty4: self.qty4, qty5: self.qty5, qty6: self.qty6, 
        qty7: self.qty7, qty8: self.qty8, qty9: self.qty9, qty10: self.qty10)
  
    end
        
    return "Created CustDetails please check #{self.order_num}"
    
  end
 
end
