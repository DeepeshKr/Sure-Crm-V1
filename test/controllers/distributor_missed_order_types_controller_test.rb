require 'test_helper'

class DistributorMissedOrderTypesControllerTest < ActionController::TestCase
  setup do
    @distributor_missed_order_type = distributor_missed_order_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_missed_order_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_missed_order_type" do
    assert_difference('DistributorMissedOrderType.count') do
      post :create, distributor_missed_order_type: { description: @distributor_missed_order_type.description, name: @distributor_missed_order_type.name, sort_order: @distributor_missed_order_type.sort_order }
    end

    assert_redirected_to distributor_missed_order_type_path(assigns(:distributor_missed_order_type))
  end

  test "should show distributor_missed_order_type" do
    get :show, id: @distributor_missed_order_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_missed_order_type
    assert_response :success
  end

  test "should update distributor_missed_order_type" do
    patch :update, id: @distributor_missed_order_type, distributor_missed_order_type: { description: @distributor_missed_order_type.description, name: @distributor_missed_order_type.name, sort_order: @distributor_missed_order_type.sort_order }
    assert_redirected_to distributor_missed_order_type_path(assigns(:distributor_missed_order_type))
  end

  test "should destroy distributor_missed_order_type" do
    assert_difference('DistributorMissedOrderType.count', -1) do
      delete :destroy, id: @distributor_missed_order_type
    end

    assert_redirected_to distributor_missed_order_types_path
  end
end
