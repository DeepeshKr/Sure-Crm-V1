class CreateFedexBillChecks < ActiveRecord::Migration
  def change
    create_table :fedex_bill_checks do |t|
      t.integer :shp_cust_nbr
      t.integer :acctno
      t.integer :invno
      t.date :invdate
      t.integer :awb
      t.date :shipdate
      t.string :shprname
      t.string :coname
      t.string :shipadd
      t.string :shprlocation
      t.string :shp_postal_code
      t.string :shipreference
      t.string :origloc, :limit => 5
      t.string :origctry, :limit => 5
      t.string :destloc, :limit => 5
      t.string :destctry, :limit => 5
      t.integer :svc1
      t.integer :pcs
      t.integer :weight
      t.integer :dimwgt
      t.string :wgttype, :limit => 5
      t.string :dimflag, :limit => 5
      t.string :billflag, :limit => 5
      t.float :ratedamt
      t.float :discount
      t.float :address_correction
      t.float :cod_fee
      t.float :freight_on_value_carriers_risk
      t.float :freight_on_value_own_risk
      t.float :fuel_surcharge
      t.float :higher_floor_delivery
      t.float :india_service_tax
      t.float :out_of_delivery_area
      t.float :billedamt
      t.string :recp_pstl_cd
      t.string :verif_name
      t.integer :verif_order_ref_id
      t.integer :verif_order_no
      t.string :verif_products
      t.integer :verif_weight
      t.integer :verif_weight_diff
      t.text :verif_comments
      t.float :verif_basic
      t.float :verif_fuel_surcharge
      t.float :verif_cod
      t.float :verif_service_tax
      t.float :verif_total_charges
      t.date :verif_upload_date
      t.timestamps null: false
    end
  end
end
