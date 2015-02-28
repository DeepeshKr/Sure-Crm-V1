class CreateCustomerOrderLists < ActiveRecord::Migration
  def change
    create_table :customer_order_lists do |t|
 t.integer  :ordernum
t.date  :orderdate 
t.string  :title, limit: 5
t.string  :fname, limit: 30
t.string  :lname , limit: 30
t.string  :add1, limit: 30
t.string  :add2, limit: 30
t.string  :add3, limit: 30
t.string  :city, limit: 20
t.integer  :pincode
t.string  :tel1, limit: 20
t.string  :tel2, limit: 20
t.string  :fax, limit: 20
t.string  :email, limit: 30
t.string  :ccnumber, limit: 16
t.string  :cvc, limit: 5
t.string  :cardtype, limit: 20
t.string  :expmonth, limit: 2
t.string  :expyear, limit: 4
t.string  :prod1, limit: 10
t.integer  :qty1
t.string  :prod2, limit: 10
t.integer  :qty2
t.string  :prod3, limit: 10
t.integer  :qty3
t.string  :prod4, limit: 10
t.integer  :qty4
t.string  :prod5, limit: 10
t.integer  :qty5
t.string  :prod6, limit: 10
t.integer  :qty6
t.string  :prod7, limit: 10
t.integer  :qty7
t.string  :prod8, limit: 10
t.integer  :qty8
t.string  :prod9, limit: 10
t.integer  :qty9
t.string  :prod10, limit: 10
t.integer  :qty10
t.string  :channel, limit: 50
t.string  :state, limit: 5
t.string  :username, limit: 50
t.integer  :oper_no
t.string  :recupd, limit: 1
t.integer  :dt_hour
t.integer  :dt_min
t.date  :birthdate  
t.string  :mstate, limit: 50
t.integer  :people
t.integer  :cards
t.string  :carddisc, limit: 50
t.string  :recfile, limit: 100
t.string  :ipadd, limit: 50
t.string  :dnis, limit: 50
t.string  :landmark, limit: 50
t.string  :chqdisc, limit: 50
t.integer  :totalamt
t.date  :trandate  
t.string  :uae_status, limit: 50
t.string  :emischeme, limit: 50
t.timestamps null: false
    end
  end
end
