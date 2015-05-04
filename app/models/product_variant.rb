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
  #validates_uniqueness_of :emailid, :allow_blank => true
  #validates_uniqueness_of :employeecode, allow_blank: false

  validates_presence_of :name
  validates_presence_of :productmasterid 
  validates_presence_of :variantbarcode
  validates_presence_of :price
  validates_presence_of :taxes
  #validates_uniqueness_of :variantbarcode, { case_sensitive: false }
    #validates :total, presence: true
  #validates_uniqueness_of :extproductcode, { case_sensitive: false }

after_create :creator

after_save :updator

     
  def productinfo
     self.name + " -- Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price')
   end



private
  def creator
   # taxes = 
   # codcharges = 
   #self.update_columns(self.total: (self.price + self.taxes + self.shipping
  end
  def updator
   # taxes = 
   # codcharges = 
   #self.update_columns(self.total: (self.price + self.taxes + self.shipping
  end
end
