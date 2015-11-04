require 'test_helper'

class DistributorMissedOrdersControllerTest < ActionController::TestCase
  setup do
    @distributor_missed_order = distributor_missed_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_missed_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_missed_order" do
    assert_difference('DistributorMissedOrder.count') do
      post :create, distributor_missed_order: { corporate_id: @distributor_missed_order.corporate_id, description: @distributor_missed_order.description, missed_type_id: @distributor_missed_order.missed_type_id, order_id: @distributor_missed_order.order_id, order_no: @distributor_missed_order.order_no, order_value: @distributor_missed_order.order_value }
    end

    assert_redirected_to distributor_missed_order_path(assigns(:distributor_missed_order))
  end

  test "should show distributor_missed_order" do
    get :show, id: @distributor_missed_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_missed_order
    assert_response :success
  end

  test "should update distributor_missed_order" do
    patch :update, id: @distributor_missed_order, distributor_missed_order: { corporate_id: @distributor_missed_order.corporate_id, description: @distributor_missed_order.description, missed_type_id: @distributor_missed_order.missed_type_id, order_id: @distributor_missed_order.order_id, order_no: @distributor_missed_order.order_no, order_value: @distributor_missed_order.order_value }
    assert_redirected_to distributor_missed_order_path(assigns(:distributor_missed_order))
  end

  test "should destroy distributor_missed_order" do
    assert_difference('DistributorMissedOrder.count', -1) do
      delete :destroy, id: @distributor_missed_order
    end

    assert_redirected_to distributor_missed_orders_path
  end
end
