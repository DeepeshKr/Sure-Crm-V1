require 'test_helper'

class FedexBillChecksControllerTest < ActionController::TestCase
  setup do
    @fedex_bill_check = fedex_bill_checks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fedex_bill_checks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fedex_bill_check" do
    assert_difference('FedexBillCheck.count') do
      post :create, fedex_bill_check: { acctno: @fedex_bill_check.acctno, address_correction: @fedex_bill_check.address_correction, awb: @fedex_bill_check.awb, billedamt: @fedex_bill_check.billedamt, billflag: @fedex_bill_check.billflag, cod_fee: @fedex_bill_check.cod_fee, coname: @fedex_bill_check.coname, destctry: @fedex_bill_check.destctry, destloc: @fedex_bill_check.destloc, dimflag: @fedex_bill_check.dimflag, dimwgt: @fedex_bill_check.dimwgt, discount: @fedex_bill_check.discount, freight_on_value_carriers_risk: @fedex_bill_check.freight_on_value_carriers_risk, freight_on_value_own_risk: @fedex_bill_check.freight_on_value_own_risk, fuel_surcharge: @fedex_bill_check.fuel_surcharge, higher_floor_delivery: @fedex_bill_check.higher_floor_delivery, india_service_tax: @fedex_bill_check.india_service_tax, invdate: @fedex_bill_check.invdate, invno: @fedex_bill_check.invno, origctry: @fedex_bill_check.origctry, origloc: @fedex_bill_check.origloc, out_of_delivery_area: @fedex_bill_check.out_of_delivery_area, pcs: @fedex_bill_check.pcs, ratedamt: @fedex_bill_check.ratedamt, recp_pstl_cd: @fedex_bill_check.recp_pstl_cd, shipadd: @fedex_bill_check.shipadd, shipdate: @fedex_bill_check.shipdate, shipreference: @fedex_bill_check.shipreference, shp_cust_nbr: @fedex_bill_check.shp_cust_nbr, shp_postal_code: @fedex_bill_check.shp_postal_code, shprlocation: @fedex_bill_check.shprlocation, shprname: @fedex_bill_check.shprname, svc1: @fedex_bill_check.svc1, weight: @fedex_bill_check.weight, wgttype: @fedex_bill_check.wgttype }
    end

    assert_redirected_to fedex_bill_check_path(assigns(:fedex_bill_check))
  end

  test "should show fedex_bill_check" do
    get :show, id: @fedex_bill_check
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fedex_bill_check
    assert_response :success
  end

  test "should update fedex_bill_check" do
    patch :update, id: @fedex_bill_check, fedex_bill_check: { acctno: @fedex_bill_check.acctno, address_correction: @fedex_bill_check.address_correction, awb: @fedex_bill_check.awb, billedamt: @fedex_bill_check.billedamt, billflag: @fedex_bill_check.billflag, cod_fee: @fedex_bill_check.cod_fee, coname: @fedex_bill_check.coname, destctry: @fedex_bill_check.destctry, destloc: @fedex_bill_check.destloc, dimflag: @fedex_bill_check.dimflag, dimwgt: @fedex_bill_check.dimwgt, discount: @fedex_bill_check.discount, freight_on_value_carriers_risk: @fedex_bill_check.freight_on_value_carriers_risk, freight_on_value_own_risk: @fedex_bill_check.freight_on_value_own_risk, fuel_surcharge: @fedex_bill_check.fuel_surcharge, higher_floor_delivery: @fedex_bill_check.higher_floor_delivery, india_service_tax: @fedex_bill_check.india_service_tax, invdate: @fedex_bill_check.invdate, invno: @fedex_bill_check.invno, origctry: @fedex_bill_check.origctry, origloc: @fedex_bill_check.origloc, out_of_delivery_area: @fedex_bill_check.out_of_delivery_area, pcs: @fedex_bill_check.pcs, ratedamt: @fedex_bill_check.ratedamt, recp_pstl_cd: @fedex_bill_check.recp_pstl_cd, shipadd: @fedex_bill_check.shipadd, shipdate: @fedex_bill_check.shipdate, shipreference: @fedex_bill_check.shipreference, shp_cust_nbr: @fedex_bill_check.shp_cust_nbr, shp_postal_code: @fedex_bill_check.shp_postal_code, shprlocation: @fedex_bill_check.shprlocation, shprname: @fedex_bill_check.shprname, svc1: @fedex_bill_check.svc1, weight: @fedex_bill_check.weight, wgttype: @fedex_bill_check.wgttype }
    assert_redirected_to fedex_bill_check_path(assigns(:fedex_bill_check))
  end

  test "should destroy fedex_bill_check" do
    assert_difference('FedexBillCheck.count', -1) do
      delete :destroy, id: @fedex_bill_check
    end

    assert_redirected_to fedex_bill_checks_path
  end
end
