class Corporate < ActiveRecord::Base
   has_one :medium
belongs_to :corporate_active_master, foreign_key: "active"
belongs_to :corporate_type, foreign_key: "corporate_type_id"
has_many :distributor_pincode_list, foreign_key: "corporate_id"
has_many :distributor_stock_summary, foreign_key: "corporate_id"
has_many :distributor_stock_ledger, foreign_key: "corporate_id"
has_many :distributor_stock_book, foreign_key: "corporate_id"
has_many :distributor_missed_order, foreign_key: "corporate_id"

validates :tally_id,  allow_blank: true, uniqueness: true
validates :cst_no,  allow_blank: true, uniqueness: true
validates :gst_no,  allow_blank: true, uniqueness: true
validates :vat_no,  allow_blank: true, uniqueness: true
validates :tin_no,  allow_blank: true, uniqueness: true
validates :web_id,  allow_blank: true, uniqueness: true
validates :pan_card_no,  allow_blank: true, uniqueness: true

# :name, :address1, :address2, :address3,
#   :landmark, :city, :pincode, :state, :district,
#   :country, :telephone1, :telephone2, :fax,
#   :website, :salute1, :first_name1, :last_name1,
#   :designation1, :mobile1, :emaild1, :salute2,
#   :first_name2, :last_name2, :designation2,
#   :mobile2, :emailid2, :salute3, :first_name3,
#   :last_name3, :designation3, :mobile3,
#   :emailid3, :description, :corporate_type_id,
#   :active, :tally_id,  :c_form,
#   :cst_no, :gst_no, :vat_no, :tin_no, :rupee_balance,
#   :web_id, :ref_no, :commission_percent, :pan_card_no

end
