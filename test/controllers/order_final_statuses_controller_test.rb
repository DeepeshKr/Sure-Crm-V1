require 'test_helper'

class OrderFinalStatusesControllerTest < ActionController::TestCase
  setup do
    @order_final_status = order_final_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_final_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_final_status" do
    assert_difference('OrderFinalStatus.count') do
      post :create, order_final_status: { description: @order_final_status.description, name: @order_final_status.name, sort_order: @order_final_status.sort_order }
    end

    assert_redirected_to order_final_status_path(assigns(:order_final_status))
  end

  test "should show order_final_status" do
    get :show, id: @order_final_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_final_status
    assert_response :success
  end

  test "should update order_final_status" do
    patch :update, id: @order_final_status, order_final_status: { description: @order_final_status.description, name: @order_final_status.name, sort_order: @order_final_status.sort_order }
    assert_redirected_to order_final_status_path(assigns(:order_final_status))
  end

  test "should destroy order_final_status" do
    assert_difference('OrderFinalStatus.count', -1) do
      delete :destroy, id: @order_final_status
    end

    assert_redirected_to order_final_statuses_path
  end
end
