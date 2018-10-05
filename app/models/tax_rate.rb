class TaxRate < ActiveRecord::Base
  validates :name ,  :presence => { :message => "Please give the name of TAX or State VAT" }
  validates :tax_rate,  :presence => { :message => "Enter the Tax Rate like this  0.125" }
  validates :reverse_rate,  :presence => { :message => "Enter Reverse Tax Rate like this 0.8889" }
  validates_numericality_of :tax_rate, allow_nil: false , numericality: { only_integer: true }, :less_than_or_equal_to => 1
  validates :reverse_rate,  :presence => { :message => "Enter Reverse Tax Rate like this 0.8889" }
  validates_numericality_of :reverse_rate, allow_nil: false , numericality: { only_integer: true }, :less_than_or_equal_to => 1
  validates :name, uniqueness: { case_sensitive: false }
  
  has_many :product_master, foreign_key: "tax_id"  
end
