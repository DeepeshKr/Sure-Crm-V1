class ReturnRate < ActiveRecord::Base
  attr_accessor :show_all, :retail_default_rate, :transfer_order_default_rate
  attr_accessor :rate_0, :note_0, :rate, :note, :rate_1, :note_1, :rate_2, :note_2
  attr_accessor :shipped_percent, :cancelled_percent, :returned_percent, :paid_percent, :transfer_total_percent,
  :transfer_total_paid_percent, :transfer_total_cancelled_percent, :shipped_cancelled_percent, :shipped_returned_percent, :shipped_paid_percent, :shipped_transfer_total_percent, :shipped_transfer_total_paid_percent, :shipped_transfer_total_cancelled_percent
  #
  # def initialize(rate, note)
  #     # Instance variables
  #     @rate = rate
  #     @note = note
  # end
    
  def show_all
   return 100
  end
  
  def retail_default_rate
   return 50
  end
  
  def transfer_order_default_rate
   return 65
  end
  
  def all_percents offset, days=0
    return_rates = ReturnRate.where("media_id is null and product_list_id is null").where(offset: offset).order(:no_of_days)
    if days > 0
     return_rates = return_rates.where(no_of_days: days)
    end
    #return_rate = return_rates .first
    
    re_return_rates = []
    return_rates.each do |return_rate|
      re_return = ReturnRate.new
  	  re_return.offset = offset
  		re_return.no_of_days = return_rate.no_of_days
      re_return.name = return_rate.name
      re_return.total = return_rate.total
  		re_return.shipped = return_rate.shipped
      re_return.cancelled = return_rate.cancelled
      re_return.returned = return_rate.returned
      re_return.paid = return_rate.paid
      re_return.transfer_total = return_rate.transfer_total
      re_return.transfer_cancelled = return_rate.transfer_cancelled
      re_return.transfer_paid = return_rate.transfer_paid
      re_return.shipped_percent = (return_rate.shipped.to_f / return_rate.total.to_f) * 100
      re_return.cancelled_percent = (return_rate.cancelled.to_f / return_rate.total.to_f) * 100
      re_return.returned_percent = (return_rate.returned.to_f / return_rate.total.to_f) * 100
      re_return.paid_percent = (return_rate.paid.to_f / return_rate.total.to_f) * 100
      re_return.transfer_total_percent = (return_rate.transfer_total.to_f / return_rate.total.to_f) * 100
      re_return.transfer_total_paid_percent = (return_rate.transfer_paid.to_f / return_rate.transfer_total.to_f) * 100
      re_return.transfer_total_cancelled_percent = (return_rate.transfer_cancelled.to_f / return_rate.transfer_total.to_f) * 100 
      re_return.shipped_cancelled_percent = (return_rate.cancelled.to_f / return_rate.shipped.to_f) * 100
      re_return.shipped_returned_percent = (return_rate.returned.to_f / return_rate.shipped.to_f) * 100
      re_return.shipped_paid_percent = (return_rate.paid.to_f / return_rate.shipped.to_f) * 100
      re_return.shipped_transfer_total_percent = (return_rate.transfer_total.to_f / return_rate.shipped.to_f) * 100
      re_return.shipped_transfer_total_paid_percent = (return_rate.transfer_paid.to_f / return_rate.transfer_total.to_f) * 100
      re_return.shipped_transfer_total_cancelled_percent = (return_rate.transfer_cancelled.to_f / return_rate.transfer_total.to_f) * 100
    
      re_return_rates << re_return
    end
    return re_return_rates
  end
  
  ### optional
  def paid_decimal offset, days
    return_rate = ReturnRate.where("media_id is null and product_list_id is null").where(offset: offset, no_of_days: days).first
    (return_rate.paid.to_f / return_rate.total.to_f)
  end
  
  def transfer_total_paid_decimal offset, days
    return_rate = ReturnRate.where("media_id is null and product_list_id is null").where(offset: offset, no_of_days: days).first
    (return_rate.transfer_paid.to_f / return_rate.transfer_total.to_f) 
  end

  
  ######
  # shipped percent for media, product variant for days skipped days
  # ext_prod_code
  # media_id
  # offset 30, 60
  # no_of_days 60
  #########
  
  def retail_best_shipped_paid_percent product_variant_id, media_id
    base_return = ReturnRate.where( product_variant_id: product_variant_id)
    product_variant = ProductVariant.find(product_variant_id)
    media = Medium.find(media_id).name
    #all_values = []
    # media_id: media_id,
    return_rate = ReturnRate.new
    
    return_rate.rate_0 = 50.0
    return_rate.note_0 = "#{product_variant.extproductcode} default value"
    return_rate.rate = 50.0
    return_rate.note = "#{product_variant.extproductcode} default value"
    return_rate.rate_1 = 0.0
    return_rate.note_1 = "Nothing for #{product_variant.extproductcode}, for 60 - 30 days for media #{media_id}"
    return_rate.rate_2 = 0.0
    return_rate.note_2 = "Nothing for #{product_variant.extproductcode}, for 60 - 60 days for media #{media_id}"
 
     #all_values << default
    if base_return.where(offset: 30, no_of_days: 60).present?
       first_check = base_return.where(offset: 30, no_of_days: 60).first
      first_no = (first_check.cancelled.to_f / first_check.shipped.to_f) * 100
      # all_values[1].key =
      # all_values[1].values = ""
      # all_values << first_no
      # return_rate_2 = ReturnRate.new
      return_rate.rate_1 = first_no.round(2)
      return_rate.note_1 = "#{product_variant.extproductcode} for 30 - 60 days (#{first_check.cancelled}/ #{first_check.shipped}) #{first_no.round(2)} for media #{media}"
    end
    
    if base_return.where(offset: 60, no_of_days: 60).present?
       second_check = base_return.where(offset: 60, no_of_days: 60).first
       if second_check.transfer_total > 0 && second_check.transfer_paid > 0
         second_no = (second_check.cancelled.to_f / second_check.shipped.to_f) * 100
         #all_values << second_no
       
         # return_rate_3 = ReturnRate.new
         if second_no.present?
           return_rate.rate_2 = second_no
           return_rate.note_2 = "#{product_variant.extproductcode} for 60 - 60 days (#{second_check.cancelled}/ #{second_check.shipped}) #{second_no.round(2)} for media #{media}"
         end
       end
    end
     
    return return_rate
  end
  
  def transfer_best_shipped_paid_percent product_variant_id, media_id
    base_return = ReturnRate.where( product_variant_id: product_variant_id)
    product_variant = ProductVariant.find(product_variant_id)
    media = Medium.find(media_id).name
    #all_values = []
    # media_id: media_id,
    return_rate = ReturnRate.new
    
    return_rate.rate_0 = 65.0
    return_rate.note_0 = "TO: #{product_variant.extproductcode} default value"
    return_rate.rate = 65.0
    return_rate.note = "TO: #{product_variant.extproductcode} default value"
    return_rate.rate_1 = 65.0
    return_rate.note_1 = "Nothing for TO #{product_variant.extproductcode}, for 60 - 30 days for media #{media_id}"
    return_rate.rate_2 = 0.0
    return_rate.note_2 = "Nothing for TO #{product_variant.extproductcode}, for 60 - 60 days for media #{media_id}"
 
     #all_values << default
     #  (return_rate.transfer_paid.to_f / return_rate.transfer_total.to_f) 
    if base_return.where(offset: 30, no_of_days: 60).present?
       first_check = base_return.where(offset: 30, no_of_days: 60).first
      first_no = (first_check.transfer_paid.to_f / first_check.transfer_total.to_f) * 100
      # all_values[1].key =
      # all_values[1].values = ""
      # all_values << first_no
      # return_rate_2 = ReturnRate.new
      
      return_rate.rate_1 = first_no.round(2)
      return_rate.note_1 = "TO #{product_variant.extproductcode} for 30 - 60 days (#{first_check.transfer_paid}/ #{first_check.transfer_total}) #{first_no.round(2)} for media #{media}"
    end
    
    if base_return.where(offset: 60, no_of_days: 60).present?
       second_check = base_return.where(offset: 60, no_of_days: 60).first
       if second_check.transfer_total > 0 && second_check.transfer_paid > 0
         second_no = (second_check.transfer_paid.to_f / second_check.transfer_total.to_f) * 100
         #all_values << second_no
       
         # return_rate_3 = ReturnRate.new
        if second_no.present?
         return_rate.rate_2 = second_no
         return_rate.note_2 = "TO #{product_variant.extproductcode} for 60 - 60 days (#{second_check.transfer_paid}/ #{second_check.transfer_total}) #{second_no.round(2)} for media #{media}"
        end
      end
    end
     
    return return_rate
    
  end
  
  private
  
  def select_return_rate
    return_rate = ReturnRate.where("media_id is null and product_list_id is null").where(offset: 60, no_of_days:60).first
  end
 
end
