class ProductVariant < ActiveRecord::Base
  belongs_to :product_master, foreign_key: "productmasterid"
  belongs_to :product_active_code, foreign_key: "activeid"
  belongs_to :product_sell_type , foreign_key: "product_sell_type_id"

  #has_many :product_variant_add_on, foreign_key: "product_variant_id"

  has_many :campaign_playlist, foreign_key: "productvariantid"
  has_many :interaction_master, foreign_key: "productvariantid"
  has_many :order_line, foreign_key: "productvariant_id" #, polymorphic: true
  has_many :product_list, foreign_key: "product_variant_id"
  has_many :media_tape, foreign_key: "product_variant_id"
  has_many :media_tape_head, foreign_key: "product_variant_id"
  has_many :distributor_stock_ledger, foreign_key: "product_variant_id"
  has_many :distributor_stock_summary, foreign_key: "product_variant_id"
  has_many :sales_ppo, foreign_key: "product_variant_id"
  has_many :campaign_playlist_to_product, foreign_key: "product_variant_id"
  has_many :product_cost_master, foreign_key: "product_variant_id"
  #validates_uniqueness_of :emailid, :allow_blank => true
  #validates_uniqueness_of :employeecode, allow_blank: false

  validates_presence_of :name
  validates_presence_of :productmasterid
  #validates_presence_of :variantbarcode
  validates_presence_of :price
  validates_presence_of :taxes
  #validates_uniqueness_of :variantbarcode, { case_sensitive: false }
  #validates :total, presence: true
  #validates_uniqueness_of :extproductcode, { case_sensitive: false }
  # validates :productmasterid, uniqueness: { scope: :price, :message => "A Product Variant with the same price has been added to the Product Master" }
  after_create :creator
  after_save :updator


  def productinfo
     self.name + " -- Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price') + " :(#{self.id})"
   end

   def productdetails
     self.name + " -- Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price') + " :(#{self.id})"
   end
   
   def full_product_details
     "#{self.name} Basic: Rs. #{self.price} Total: Rs.#{self.total} >> (#{self.product_active_code.name}) >> [#{self.id}]"
   end

  def get_product_value
    total = (self.price.to_f  * 0.888889 + self.shipping.to_f * 0.98125).to_i
  end
  
  def product_mrp
    (self.price + self.shipping).to_i
  end
  
  def calculate_product_total
    self.total = self.price +self.taxes + self.shipping
  end
  
  def get_product_value
    reverse_vat_rate = TaxRate.find(10001)
    reverse_ship_rate = TaxRate.find(10020)
    
    total = (self.product_variant.price.to_f  * reverse_vat_rate.reverse_rate.to_f + self.product_variant.shipping.to_f * reverse_ship_rate.reverse_rate.to_f).to_i
  end
  
  def get_basic_value
    reverse_vat_rate = TaxRate.find(10001)
    reverse_ship_rate = TaxRate.find(10020)
    
    total = (self.product_variant.price.to_f  * reverse_vat_rate.reverse_rate.to_f).round(2)
  end
  
  def self.to_csv
    attributes = %w{product_variant_id name prod price shipping active} #customize columns here

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |car|
        csv << attributes.map{ |attr| car.send(attr) }
      end
    end
  end
  
  def product_variant_id
    self.id
  end
  def prod
    self.extproductcode
  end
  
  def active
    return true if self.activeid == 10000
    return false
  end
  
private
  
  def creator
    ProductCostMaster.create_product_cost_master self.id
  end
  
  def updator
    ProductCostMaster.create_product_cost_master self.id
  end
  
end
