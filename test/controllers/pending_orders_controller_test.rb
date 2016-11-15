require 'test_helper'

class PendingOrdersControllerTest < ActionController::TestCase
  setup do
    @pending_order = pending_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pending_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pending_order" do
    assert_difference('PendingOrder.count') do
      post :create, pending_order: { cod_amount: @pending_order.cod_amount, cod_amount: @pending_order.cod_amount, courier_list_id: @pending_order.courier_list_id, order_dispatch_status_id: @pending_order.order_dispatch_status_id, order_no: @pending_order.order_no, order_ref_id: @pending_order.order_ref_id, pay_u_amount: @pending_order.pay_u_amount, pay_u_amount: @pending_order.pay_u_amount, pay_u_status_id: @pending_order.pay_u_status_id }
    end

    assert_redirected_to pending_order_path(assigns(:pending_order))
  end

  test "should show pending_order" do
    get :show, id: @pending_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pending_order
    assert_response :success
  end

  test "should update pending_order" do
    patch :update, id: @pending_order, pending_order: { cod_amount: @pending_order.cod_amount, cod_amount: @pending_order.cod_amount, courier_list_id: @pending_order.courier_list_id, order_dispatch_status_id: @pending_order.order_dispatch_status_id, order_no: @pending_order.order_no, order_ref_id: @pending_order.order_ref_id, pay_u_amount: @pending_order.pay_u_amount, pay_u_amount: @pending_order.pay_u_amount, pay_u_status_id: @pending_order.pay_u_status_id }
    assert_redirected_to pending_order_path(assigns(:pending_order))
  end

  test "should destroy pending_order" do
    assert_difference('PendingOrder.count', -1) do
      delete :destroy, id: @pending_order
    end

    assert_redirected_to pending_orders_path
  end
end
