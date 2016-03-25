class ReturnRate < ActiveRecord::Base
  attr_accessor :show_all, :retail_default_rate, :transfer_order_default_rate
  
  def show_all
   return 100
  end
  
  def retail_default_rate
   return 50
  end
  
  def transfer_order_default_rate
   return 65
  end
  
  def shipped_percent
    (self.shipped.to_f / self.total.to_f) * 100
  end
  
  def cancelled_percent
    (self.cancelled.to_f / self.total.to_f) * 100
  end
  
  def returned_percent
    (self.returned.to_f / self.total.to_f) * 100
  end
  
  def paid_percent
    (self.paid.to_f / self.total.to_f) * 100
  end
  
  def transfer_total_percent
    (self.transfer_total.to_f / self.total.to_f) * 100
  end
  
  def transfer_total_paid_percent
    (self.transfer_paid.to_f / self.transfer_total.to_f) * 100
  end
  
  def transfer_total_cancelled_percent
    (self.transfer_cancelled.to_f / self.transfer_total.to_f) * 100
  end
  
  ### optional
  def paid_decimal
    (self.paid.to_f / self.total.to_f)
  end
  
  def transfer_total_paid_decimal
    (self.transfer_paid.to_f / self.transfer_total.to_f) 
  end
  ######
  # shipped percent
  #########
  
  def shipped_cancelled_percent
    (self.cancelled.to_f / self.shipped.to_f) * 100
  end

  def shipped_returned_percent
    (self.returned.to_f / self.shipped.to_f) * 100
  end

  def shipped_paid_percent
    (self.paid.to_f / self.shipped.to_f) * 100
  end

  def shipped_transfer_total_percent
    (self.transfer_total.to_f / self.shipped.to_f) * 100
  end

  def shipped_transfer_total_paid_percent
    (self.transfer_paid.to_f / self.transfer_total.to_f) * 100
  end

  def shipped_transfer_total_cancelled_percent
    (self.transfer_cancelled.to_f / self.transfer_total.to_f) * 100
  end

end
