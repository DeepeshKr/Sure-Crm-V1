require 'test_helper'

class OrderDispatchStatusesControllerTest < ActionController::TestCase
  setup do
    @order_dispatch_status = order_dispatch_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_dispatch_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_dispatch_status" do
    assert_difference('OrderDispatchStatus.count') do
      post :create, order_dispatch_status: { description: @order_dispatch_status.description, name: @order_dispatch_status.name, sort_order: @order_dispatch_status.sort_order }
    end

    assert_redirected_to order_dispatch_status_path(assigns(:order_dispatch_status))
  end

  test "should show order_dispatch_status" do
    get :show, id: @order_dispatch_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_dispatch_status
    assert_response :success
  end

  test "should update order_dispatch_status" do
    patch :update, id: @order_dispatch_status, order_dispatch_status: { description: @order_dispatch_status.description, name: @order_dispatch_status.name, sort_order: @order_dispatch_status.sort_order }
    assert_redirected_to order_dispatch_status_path(assigns(:order_dispatch_status))
  end

  test "should destroy order_dispatch_status" do
    assert_difference('OrderDispatchStatus.count', -1) do
      delete :destroy, id: @order_dispatch_status
    end

    assert_redirected_to order_dispatch_statuses_path
  end
end
