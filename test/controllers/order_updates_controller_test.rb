require 'test_helper'

class OrderUpdatesControllerTest < ActionController::TestCase
  setup do
    @order_update = order_updates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_updates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_update" do
    assert_difference('OrderUpdate.count') do
      post :create, order_update: { cancel_date: @order_update.cancel_date, order_date: @order_update.order_date, order_id: @order_update.order_id, orderno: @order_update.orderno, paid_date: @order_update.paid_date, process_date: @order_update.process_date, return_date: @order_update.return_date, shipped_date: @order_update.shipped_date }
    end

    assert_redirected_to order_update_path(assigns(:order_update))
  end

  test "should show order_update" do
    get :show, id: @order_update
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_update
    assert_response :success
  end

  test "should update order_update" do
    patch :update, id: @order_update, order_update: { cancel_date: @order_update.cancel_date, order_date: @order_update.order_date, order_id: @order_update.order_id, orderno: @order_update.orderno, paid_date: @order_update.paid_date, process_date: @order_update.process_date, return_date: @order_update.return_date, shipped_date: @order_update.shipped_date }
    assert_redirected_to order_update_path(assigns(:order_update))
  end

  test "should destroy order_update" do
    assert_difference('OrderUpdate.count', -1) do
      delete :destroy, id: @order_update
    end

    assert_redirected_to order_updates_path
  end
end
