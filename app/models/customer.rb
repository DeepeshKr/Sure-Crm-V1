class Customer < ActiveRecord::Base
  has_many :customer_address
  VALID_MOBILE_REGEX = /[0-9]+(\%7C[0-9]+)*/
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :emailid, allow_blank: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
   validates :alt_emailid, allow_blank: true, uniqueness: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }                 
validates :first_name,  presence: true, length: { maximum: 50 }
validates :mobile,  presence: true
validates :alt_mobile,  allow_blank: true,   format: { with: VALID_MOBILE_REGEX }, uniqueness: true, length: { maximum: 12 }
end
