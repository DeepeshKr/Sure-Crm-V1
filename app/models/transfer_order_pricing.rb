class TransferOrderPricing
     include ActiveModel::Validations

  	attr_accessor :basic, :shipping, :cod,:total_product_price, :vat_percent, :commission, :tax_refund, :basic_price, :base_price, :vat_charge, :cst, :c_form, :final_total, :full_product_name, :for_state, :reverse_rate, :state, :product_code, :landed_price

    validates :product_code,  :presence => { :message => "Please select the product" }

    validates :state,  :presence => { :message => "Please select the state" }

end
