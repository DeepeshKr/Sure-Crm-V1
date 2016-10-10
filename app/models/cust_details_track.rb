class CustDetailsTrack < ActiveRecord::Base
  belongs_to :order_master
  has_many :cust_details_track_log
  
  def self.update_all_details
    
  end
  
  def update_for_order_id order_id
    
  end
  
  def update_for_ordernum order_num
    
  end
  
  def customer_order_list_date
    return "Not found" if CustomerOrderList.find(self.ext_ref_id).blank?
    return "Not found" if CustomerOrderList.find(self.ext_ref_id).orderdate.blank?
    (CustomerOrderList.find(self.ext_ref_id).orderdate + 330.minutes).strftime("%d-%b-%Y")
  end
  
  def custdetails_order_date
    return "Not found" if CUSTDETAILS.find_by_ordernum(self.custdetails).blank?
    CUSTDETAILS.find_by_ordernum(self.custdetails).orderdate.strftime("%d-%b-%Y")
  end
  
  def custdetails_order_time
    return "Not found" if CUSTDETAILS.find_by_ordernum(self.custdetails).blank?
    custdetail = CUSTDETAILS.find_by_ordernum(self.custdetails)
    "#{custdetail.dt_hour}:#{custdetail.dt_min}"
  end
  
  def custdetails_in_date
    return "Not found" if CUSTDETAILS.find_by_ordernum(self.custdetails).blank?
    (CUSTDETAILS.find_by_ordernum(self.custdetails).in_date).strftime("%d-%b-%Y")
  end
  
  def processed
    to_vpp = "VPP: #{self.vpp}" if self.vpp
    to_dealtran = "DEALTRAN: #{self.dealtran}" if self.dealtran
    
    if self.custdetails.blank?
      return "Found #{to_vpp} but NO CUSTDETAILS" if self.vpp
      return "Found #{to_dealtran} but NO CUSTDETAILS" if self.dealtran
      return "NO CUSTDETAILS"
    end
    
    "CUSTDETAILS #{self.custdetails ||= "NA"} to #{to_vpp}#{to_dealtran}"
    
  end
  
  
  private
  
  def self.update_with_order_master_id order_id
    t = Time.zone.now + 330.minutes
    #check if order_ref_id present
    cust_details_track = CustDetailsTrack.find_by_order_master_id(order_id)
    order_master = OrderMaster.find(order_id)
    if order_master.external_order_no
      customer_order_list = CustomerOrderList.find_by_ordernum(order_master.external_order_no) 
      custdetails = CUSTDETAILS.find_by_ordernum(order_master.external_order_no) 
      vpp = VPP.find_by_custref(order_master.external_order_no) 
      dealtran = DEALTRAN.find_by_custref(order_master.external_order_no) 
    end
    
    products = ""
    if order_master.order_line.present?
      #products = o.order_line.each(&:description)
      order_master.order_line.each do |ord| products << ord.description end
    end
    
    if cust_details_track.blank?
      
      cust_details_track = CustDetailsTrack.new do |n|
        n.order_master_id = order_id
        n.order_ref_id = order_master.external_order_no
        n.order_date = order_master.orderdate + 330.minutes
        
        if order_master.external_order_no
          n.ext_ref_id = customer_order_list.id if customer_order_list
          n.custdetails = custdetails.ordernum if custdetails
          n.vpp = vpp.custref if vpp    
          n.dealtran = dealtran.custref if dealtran
        end
        
        #n.last_call_back_on 
        n.no_of_attempts = 0
        n.mobile = order_master.mobile
        n.alt_mobile = (order_master.customer_address.telephone2[0..19].upcase if order_master.customer_address.telephone2.present?)
        n.products = products
        n.current_status = "New"
      end
      cust_details_track.save
      
      CustDetailsTrackLog.update_log(cust_details_track.id,"New", "New row created with values CUSTDETAILS: #{cust_details_track.custdetails} VPP: #{cust_details_track.vpp} DEALTRAN: #{cust_details_track.dealtran}")
      
    else
        cust_details_track.update(order_ref_id: order_master.external_order_no,
        order_date: order_master.orderdate + 330.minutes,
        mobile: order_master.mobile,
        alt_mobile: (order_master.customer_address.telephone2[0..19].upcase if order_master.customer_address.telephone2.present?),
        products: products)
        
        if order_master.external_order_no
          cust_details_track.update(ext_ref_id: (customer_order_list.id if customer_order_list),
          custdetails: (custdetails.ordernum if custdetails),
          vpp: (vpp.custref if vpp),
          dealtran: (dealtran.custref if dealtran),
          current_status: "Re Created")
        end
        
        CustDetailsTrackLog.update_log(cust_details_track.id,"Updated", "Re Created entire row with values CUSTDETAILS: #{cust_details_track.custdetails} VPP: #{cust_details_track.vpp} DEALTRAN: #{cust_details_track.dealtran}")
    end
    
    return cust_details_track.id
    
  end
  
end
