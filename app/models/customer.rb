class Customer < ActiveRecord::Base

#validates_presence_of :mobile, :first_name

  has_many :customer_address, foreign_key: "customer_id"
  has_many :interaction_master, foreign_key: "customer_id"
  has_many :order_master, foreign_key: "customer_id"
  has_many :order_line, :through => :order_master, foreign_key: "customer_id" #, :source => :customer

  has_many :customer_credit_card, foreign_key: "customer_id"
  has_many :message_on_order, foreign_key: "customer_id"

  accepts_nested_attributes_for :customer_address
  accepts_nested_attributes_for :interaction_master
  accepts_nested_attributes_for :order_master
  #validates_associated :order_master
  validates_associated :customer_address


  #accepts_nested_attributes_for :order_master, :reject_if => lambda { |a| a[:media_id].blank? }

attr_accessor :mismatched_campaign
attr_accessor :comments

 VALID_MOBILE_REGEX = /[0-9]+(\%7C[0-9]+)*/
 VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#uniqueness: true,
 validates :emailid, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
                    #, uniqueness: { case_sensitive: false }

 validates :alt_emailid, allow_blank: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
                    #, uniqueness: { case_sensitive: false }

 validates_presence_of :mobile
#validates_presence_of :first_name
# validates :first_name, presence: true
validates :first_name,  :presence => { :message => "Need a proper first name!" }
validates :alt_mobile,  allow_blank: true,   format: { with: VALID_MOBILE_REGEX }, length: { maximum: 12 }, :presence => { :message => "Enter only numbers" } #, uniqueness: true,

def gender
  return nil if self.salute.blank?
  case self.salute
      when "Mr"
          return "M"
      when "Mrs"
          return "F"
      when "Ms"
          return "F"
      else
        return nil  
  end
end

def fullname
  #if self.first_name.present? || self.salute.present? || self.last_name.present?
    return "#{self.salute} #{self.first_name}  #{self.last_name}"
    #(self.salute ||= nil) + " " + (self.first_name ||= nil) + " " + (self.last_name ||= nil)
    #else
    #return "NA"
    #end
end
def upper_full_name
  salute = self.salute[0..4].upcase.strip if self.salute.present?
  fname = self.first_name[0..29].upcase.strip if self.first_name.present?
  lname = self.last_name[0..29].upcase.strip if self.last_name.present?
  return "#{salute} #{fname} #{lname}"
end

def name
  return "#{self.first_name}  #{self.last_name}"
end

def from_state
  mystate = CustomerAddress.where(customer_id: self.id)
    if mystate.present?
        mystate.last.state
      else
        "No address"
    end
end



end
