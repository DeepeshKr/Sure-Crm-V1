require 'test_helper'

class MessageOnOrdersControllerTest < ActionController::TestCase
  setup do
    @message_on_order = message_on_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_on_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_on_order" do
    assert_difference('MessageOnOrder.count') do
      post :create, message_on_order: { alt_mobile_no: @message_on_order.alt_mobile_no, customer_id: @message_on_order.customer_id, message: @message_on_order.message, message_status_id: @message_on_order.message_status_id, message_type_id: @message_on_order.message_type_id, mobile_no: @message_on_order.mobile_no, response: @message_on_order.response }
    end

    assert_redirected_to message_on_order_path(assigns(:message_on_order))
  end

  test "should show message_on_order" do
    get :show, id: @message_on_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message_on_order
    assert_response :success
  end

  test "should update message_on_order" do
    patch :update, id: @message_on_order, message_on_order: { alt_mobile_no: @message_on_order.alt_mobile_no, customer_id: @message_on_order.customer_id, message: @message_on_order.message, message_status_id: @message_on_order.message_status_id, message_type_id: @message_on_order.message_type_id, mobile_no: @message_on_order.mobile_no, response: @message_on_order.response }
    assert_redirected_to message_on_order_path(assigns(:message_on_order))
  end

  test "should destroy message_on_order" do
    assert_difference('MessageOnOrder.count', -1) do
      delete :destroy, id: @message_on_order
    end

    assert_redirected_to message_on_orders_path
  end
end
