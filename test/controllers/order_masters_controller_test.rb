require 'test_helper'

class OrderMastersControllerTest < ActionController::TestCase
  setup do
    @order_master = order_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_master" do
    assert_difference('OrderMaster.count') do
      post :create, order_master: { billno: @order_master.billno, campaignplaylist_id: @order_master.campaignplaylist_id, codcharges: @order_master.codcharges, customer_address_id: @order_master.customer_address_id, customer_id: @order_master.customer_id, employee_id: @order_master.employee_id, employeecode: @order_master.employeecode, external_order_no: @order_master.external_order_no, notes: @order_master.notes, orderdate: @order_master.orderdate, orderpaymentmode_id: @order_master.orderpaymentmode_id, orderstatusmaster_id: @order_master.orderstatusmaster_id, pieces: @order_master.pieces, shipping: @order_master.shipping, subtotal: @order_master.subtotal, taxes: @order_master.taxes, total: @order_master.total }
    end

    assert_redirected_to order_master_path(assigns(:order_master))
  end

  test "should show order_master" do
    get :show, id: @order_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_master
    assert_response :success
  end

  test "should update order_master" do
    patch :update, id: @order_master, order_master: { billno: @order_master.billno, campaignplaylist_id: @order_master.campaignplaylist_id, codcharges: @order_master.codcharges, customer_address_id: @order_master.customer_address_id, customer_id: @order_master.customer_id, employee_id: @order_master.employee_id, employeecode: @order_master.employeecode, external_order_no: @order_master.external_order_no, notes: @order_master.notes, orderdate: @order_master.orderdate, orderpaymentmode_id: @order_master.orderpaymentmode_id, orderstatusmaster_id: @order_master.orderstatusmaster_id, pieces: @order_master.pieces, shipping: @order_master.shipping, subtotal: @order_master.subtotal, taxes: @order_master.taxes, total: @order_master.total }
    assert_redirected_to order_master_path(assigns(:order_master))
  end

  test "should destroy order_master" do
    assert_difference('OrderMaster.count', -1) do
      delete :destroy, id: @order_master
    end

    assert_redirected_to order_masters_path
  end
end
