require 'test_helper'

class OrderLineDispatchStatusesControllerTest < ActionController::TestCase
  setup do
    @order_line_dispatch_status = order_line_dispatch_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_line_dispatch_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_line_dispatch_status" do
    assert_difference('OrderLineDispatchStatus.count') do
      post :create, order_line_dispatch_status: { name: @order_line_dispatch_status.name, sortorder: @order_line_dispatch_status.sortorder }
    end

    assert_redirected_to order_line_dispatch_status_path(assigns(:order_line_dispatch_status))
  end

  test "should show order_line_dispatch_status" do
    get :show, id: @order_line_dispatch_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_line_dispatch_status
    assert_response :success
  end

  test "should update order_line_dispatch_status" do
    patch :update, id: @order_line_dispatch_status, order_line_dispatch_status: { name: @order_line_dispatch_status.name, sortorder: @order_line_dispatch_status.sortorder }
    assert_redirected_to order_line_dispatch_status_path(assigns(:order_line_dispatch_status))
  end

  test "should destroy order_line_dispatch_status" do
    assert_difference('OrderLineDispatchStatus.count', -1) do
      delete :destroy, id: @order_line_dispatch_status
    end

    assert_redirected_to order_line_dispatch_statuses_path
  end
end
