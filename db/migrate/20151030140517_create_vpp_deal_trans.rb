class CreateVppDealTrans < ActiveRecord::Migration
  def change
    create_table :vpp_deal_trans do |t|
      t.date :actdate
      t.string :action, :limit => 10
      t.string :add1, :limit => 40
      t.string :add2, :limit => 40
      t.string :add3, :limit => 40
      t.string :barcode, :limit => 25
      t.string :barcode2, :limit => 25
      t.string :barcode3, :limit => 25
      t.integer :basicprice, :limit =>5
      t.string :cfo, :limit =>1
      t.integer :channel, :limit =>3
      t.string :city, :limit =>20
      t.date :claimdate 
      t.integer :codamt, :limit =>2
      t.integer :convcharges, :limit =>5
      t.string :cou, :limit => 1
      t.integer :custref, :limit => 12
      t.integer :debitnote, :limit =>5
      t.date :debitnotedate 
      t.date :delvdate 
      t.string :deo, :limit =>10
      t.string :dept, :limit =>20
      t.string :despatch, :limit =>3
      t.string :dist, :limit =>1
      t.integer :distcode, :limit =>10
      t.string :distname, :limit =>50
      t.string :dt_hour, :limit =>2
      t.string :dt_min, :limit =>2
      t.string :email, :limit =>30
      t.string :emi, :limit =>5
      t.date :entrydate 
      t.string :fax, :limit =>20
      t.string :fname, :limit =>30
      t.date :invdate 
      t.string :fsize, :limit =>1
      t.string :invoice, :limit =>10
      t.integer :invoiceamount, :limit =>6
      t.string :landmark, :limit => 30
      t.integer :letter, :limit => 1
      t.string :lessprod, :limit => 6
      t.string :lname, :limit => 30
      t.date :loydate 
      t.string :manifest, :limit => 8
      t.string :modby, :limit => 10
      t.date :moddt 
      t.integer :notice, :limit => 1
      t.integer :normal, :limit => 6
      t.integer :operator, :limit => 3
      t.string :order_number, :limit => 15
      t.date :orderdate 
      t.string :orderno, :limit => 15
      t.string :ordersource, :limit => 1
      t.integer :paidamt, :limit => 6
      t.date :paiddate 
      t.string :ordertype, :limit =>1
      t.integer :pin, :limit => 6
      t.integer :postage, :limit => 5
      t.date :probag 
      t.string :prod, :limit => 6
      t.integer :qty, :limit => 2
      t.string :remarks, :limit => 1
      t.integer :refundamt, :limit => 5
      t.string :refundcheck, :limit => 10
      t.date :refundcheckdate 
      t.date :refunddate 
      t.date :returndate 
      t.integer :sanction, :limit => 5
      t.date :shdate 
      t.integer :shipped, :limit => 1
      t.string :state, :limit => 3
      t.string :status, :limit => 20
      t.date :statusdate 
      t.integer :taxamt, :limit => 5
      t.decimal :taxper, precision: 5, scale: 2
      t.string :tel1, :limit => 20
      t.string :tel2, :limit => 20
      t.string :tempstatus, :limit => 1
      t.date :tempstatusdate 
      t.date :temptrandate 
      t.string :title, :limit => 3
      t.date :trandate 
      t.string :transfer, :limit => 1
      t.string :trantype, :limit => 1
      t.integer :vpp, :limit => 1
      t.decimal :weight, precision: 6, scale: 2
      t.integer :invoicerefno, :limit => 12
      t.text :description
      t.integer :order_last_mile_id
      t.integer :order_final_status_id, :limit => 6
      t.timestamps null: false
    end
  end
end
