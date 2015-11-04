require 'test_helper'

class VppDealTransControllerTest < ActionController::TestCase
  setup do
    @vpp_deal_tran = vpp_deal_trans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vpp_deal_trans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vpp_deal_tran" do
    assert_difference('VppDealTran.count') do
      post :create, vpp_deal_tran: { actdate: @vpp_deal_tran.actdate, action: @vpp_deal_tran.action, add1: @vpp_deal_tran.add1, add2: @vpp_deal_tran.add2, add3: @vpp_deal_tran.add3, barcode: @vpp_deal_tran.barcode }
    end

    assert_redirected_to vpp_deal_tran_path(assigns(:vpp_deal_tran))
  end

  test "should show vpp_deal_tran" do
    get :show, id: @vpp_deal_tran
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vpp_deal_tran
    assert_response :success
  end

  test "should update vpp_deal_tran" do
    patch :update, id: @vpp_deal_tran, vpp_deal_tran: { actdate: @vpp_deal_tran.actdate, action: @vpp_deal_tran.action, add1: @vpp_deal_tran.add1, add2: @vpp_deal_tran.add2, add3: @vpp_deal_tran.add3, barcode: @vpp_deal_tran.barcode }
    assert_redirected_to vpp_deal_tran_path(assigns(:vpp_deal_tran))
  end

  test "should destroy vpp_deal_tran" do
    assert_difference('VppDealTran.count', -1) do
      delete :destroy, id: @vpp_deal_tran
    end

    assert_redirected_to vpp_deal_trans_path
  end
end
