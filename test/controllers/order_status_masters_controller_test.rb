require 'test_helper'

class OrderStatusMastersControllerTest < ActionController::TestCase
  setup do
    @order_status_master = order_status_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_status_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_status_master" do
    assert_difference('OrderStatusMaster.count') do
      post :create, order_status_master: { name: @order_status_master.name, sortorder: @order_status_master.sortorder }
    end

    assert_redirected_to order_status_master_path(assigns(:order_status_master))
  end

  test "should show order_status_master" do
    get :show, id: @order_status_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_status_master
    assert_response :success
  end

  test "should update order_status_master" do
    patch :update, id: @order_status_master, order_status_master: { name: @order_status_master.name, sortorder: @order_status_master.sortorder }
    assert_redirected_to order_status_master_path(assigns(:order_status_master))
  end

  test "should destroy order_status_master" do
    assert_difference('OrderStatusMaster.count', -1) do
      delete :destroy, id: @order_status_master
    end

    assert_redirected_to order_status_masters_path
  end
end
