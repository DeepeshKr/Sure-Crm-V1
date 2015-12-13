class DistributorMissedPincode < ActiveRecord::Base
  # validates :pincode,  :presence => { :message => "Need a pincode!" }
  # validates_uniqueness_of :pincode, allow_blank: false
  validates :pincode, uniqueness: true

  def self.create_or_update_pincode(pincode, order_value)
    t = Time.zone.now + 330.minutes
    pin_codes = DistributorMissedPincode.where(pincode: pincode)
    if pin_codes.present?
      pin_code = pin_codes.first
      total_orders = (pin_code.no_of_orders ||= 0) + 1
      total_value = (pin_code.total_value ||= 0) + (order_value ||= 0)
      pin_code.update(no_of_orders: total_orders, total_value: total_value, last_ran_on: t)
    else
      DistributorMissedPincode.create(pincode: pincode,no_of_orders: 1, total_value: (order_value ||= 0), last_ran_on: t, description: "created the first record for this pincode on #{t}")
    end
  end
end
