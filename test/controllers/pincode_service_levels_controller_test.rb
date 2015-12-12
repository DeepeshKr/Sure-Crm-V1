require 'test_helper'

class PincodeServiceLevelsControllerTest < ActionController::TestCase
  setup do
    @pincode_service_level = pincode_service_levels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pincode_service_levels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pincode_service_level" do
    assert_difference('PincodeServiceLevel.count') do
      post :create, pincode_service_level: { cod_avail: @pincode_service_level.cod_avail, courier_id: @pincode_service_level.courier_id, description: @pincode_service_level.description, distributor_avail: @pincode_service_level.distributor_avail, last_ran_on: @pincode_service_level.last_ran_on, paid_order: @pincode_service_level.paid_order, paid_value: @pincode_service_level.paid_value, pincode: @pincode_service_level.pincode, time_to_deliver: @pincode_service_level.time_to_deliver, total_orders: @pincode_service_level.total_orders, total_value: @pincode_service_level.total_value }
    end

    assert_redirected_to pincode_service_level_path(assigns(:pincode_service_level))
  end

  test "should show pincode_service_level" do
    get :show, id: @pincode_service_level
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pincode_service_level
    assert_response :success
  end

  test "should update pincode_service_level" do
    patch :update, id: @pincode_service_level, pincode_service_level: { cod_avail: @pincode_service_level.cod_avail, courier_id: @pincode_service_level.courier_id, description: @pincode_service_level.description, distributor_avail: @pincode_service_level.distributor_avail, last_ran_on: @pincode_service_level.last_ran_on, paid_order: @pincode_service_level.paid_order, paid_value: @pincode_service_level.paid_value, pincode: @pincode_service_level.pincode, time_to_deliver: @pincode_service_level.time_to_deliver, total_orders: @pincode_service_level.total_orders, total_value: @pincode_service_level.total_value }
    assert_redirected_to pincode_service_level_path(assigns(:pincode_service_level))
  end

  test "should destroy pincode_service_level" do
    assert_difference('PincodeServiceLevel.count', -1) do
      delete :destroy, id: @pincode_service_level
    end

    assert_redirected_to pincode_service_levels_path
  end
end
