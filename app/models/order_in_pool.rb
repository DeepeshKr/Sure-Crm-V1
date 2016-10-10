class OrderInPool

attr_accessor :nos, :value, :percent, :from_date, :to_date, :pool_name, :custdetails_order, :sure_crm_orders, :missed_order_nos, :missed_order_value, :total_nos, :total_value

  def self.between_date from_date, to_date, show_missed
    
    
  #  @total_order_value = @cust_details_tracks.sum(:order_master.total_value)
   
    
    set_order_in_pools = []
    
    from_date = from_date.beginning_of_day #- 330.minutes
    to_date = to_date.end_of_day 
     
    cust_details_tracks = CustDetailsTrack.where('order_date >= ? AND order_date <= ?', from_date,
    to_date).joins(:order_master).where('ORDER_MASTERS.ORDER_STATUS_MASTER_ID > 10000')
    
    if show_missed == "true"
     cust_details_tracks = cust_details_tracks.where("custdetails is null")
    end
    
   # missed_order_value = cust_details_tracks.where("custdetails is null").joins(:order_master).sum(:total)
    total_order_in_pool = OrderInPool.new  
    
    total_order_in_pool.total_nos = cust_details_tracks.count
    total_order_in_pool.total_value = cust_details_tracks.sum(:total)
    
    total_order_in_pool.total_nos = cust_details_tracks.count
    total_order_in_pool.total_value = cust_details_tracks.sum(:total)
    total_order_in_pool.from_date = from_date.strftime("%d-%b-%Y %H:%M:%S")
    total_order_in_pool.to_date = to_date.strftime("%d-%b-%Y %H:%M:%S")
    
    
    custdetails_order = cust_details_tracks.where("custdetails is not null").count(:custdetails)
    sure_crm_orders = cust_details_tracks.count(:order_ref_id)
    missed_order_nos = sure_crm_orders - custdetails_order
    missed_order_value = cust_details_tracks.where("custdetails is null").joins(:order_master).sum(:total)
    
    total_order_in_pool.custdetails_order = custdetails_order
    total_order_in_pool.sure_crm_orders = sure_crm_orders
    total_order_in_pool.missed_order_nos = missed_order_nos
    total_order_in_pool.missed_order_value = missed_order_value
    total_order_in_pool.pool_name = nil
    
    order_status_masters = OrderStatusMaster.all.order(:sortorder).where("sortorder > 1 ")
    
    order_status_masters.each do |status|
    
       cust_details_tracks = CustDetailsTrack.where('order_date >= ? AND order_date <= ?', from_date,       to_date).joins(:order_master).where("order_masters.order_status_master_id = ?", status.id)
       
       if show_missed == "true"
        cust_details_tracks = cust_details_tracks.where("custdetails is null")
       end
       
      next if cust_details_tracks.blank?
    
        get_order_in_pool = OrderInPool.new
      
        get_order_in_pool.nos = cust_details_tracks.count
        get_order_in_pool.value = cust_details_tracks.sum(:total)
        get_order_in_pool.pool_name = status.name
        get_order_in_pool.percent = (get_order_in_pool.value.to_f / total_order_in_pool.total_value.to_f) * 100  
      set_order_in_pools << get_order_in_pool
    
    end
    
   
    set_order_in_pools << total_order_in_pool
    
    return set_order_in_pools
     
  end

end