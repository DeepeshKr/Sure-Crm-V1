class ChangeInvoiceInVppDealTran < ActiveRecord::Migration
  # rails g migration ChangeInvoiceInVppDealTran
  def change
    change_column :vpp_deal_trans, :basicprice, :decimal, precision: 8, scale: 2
    change_column :vpp_deal_trans, :invoiceamount, :decimal, precision: 8, scale: 2
    change_column :vpp_deal_trans, :convcharges, :decimal, precision: 8, scale: 2
    change_column :vpp_deal_trans, :codamt, :decimal, precision: 8, scale: 2
  end
end
