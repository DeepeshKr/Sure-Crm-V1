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

after_create :creator

after_save :updator


  def productinfo
     self.name + " -- Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price')
   end

   def productdetails
     self.name + " -- Basic: Rs." + (self.price.to_s ||= 'No Price') + " -- Total: Rs."  + (self.total.to_s ||= 'No Price')
   end
   
  def get_product_value
    total = (self.price.to_f  * 0.888889 + self.shipping.to_f * 0.98125).to_i
  end
private
  def create_product_cost_master
    #check if the prod has pricing details entered
    #if not found create new record
  product_cost = ProductCostMaster.where(prod: self.extproductcode)
    if product_cost.blank?

        ProductCostMaster.create(prod: self.extproductcode,
          product_id: self.product_master_id,
          :product_cost => 0,
          :basic_cost => self.price * 0.8888888,
          :shipping_handling => self.shipping * 0.88888888,
          :postage => 0,
          :tel_cost => 0,
          :transf_order_basic => (self.price * 0.8888888 + self.shipping * 0.88888888) * 0.86,
          :dealer_network_basic => (self.price * 0.8888888 + self.shipping * 0.88888888) * 0.70,
          :wholesale_variable_cost => 0,
          :royalty => 0,
          :cost_of_return => 0,
          :call_centre_commission => 0)

    else

      product_cost.update(product_id: self.product_master_id,
        :product_cost => 0,
        :basic_cost => self.price * 0.8888888,
        :shipping_handling => self.shipping * 0.88888888,
        :postage => 0,
        :tel_cost => 0,
        :transf_order_basic => (self.price * 0.8888888 + self.shipping * 0.88888888) * 0.86,
        :dealer_network_basic => (self.price * 0.8888888 + self.shipping * 0.88888888) * 0.70,
        :wholesale_variable_cost => 0,
        :royalty => 0,
        :cost_of_return => 0,
        :call_centre_commission => 0)
    end
  end
  def creator
    create_product_cost_master
   # taxes =
   # codcharges =
   #self.update_columns(self.total: (self.price + self.taxes + self.shipping
  end
  def updator
    create_product_cost_master
   # taxes =
   # codcharges =
   #self.update_columns(self.total: (self.price + self.taxes + self.shipping
  end
end
