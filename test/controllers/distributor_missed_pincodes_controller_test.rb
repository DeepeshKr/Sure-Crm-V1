require 'test_helper'

class DistributorMissedPincodesControllerTest < ActionController::TestCase
  setup do
    @distributor_missed_pincode = distributor_missed_pincodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_missed_pincodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_missed_pincode" do
    assert_difference('DistributorMissedPincode.count') do
      post :create, distributor_missed_pincode: { description: @distributor_missed_pincode.description, last_ran_on: @distributor_missed_pincode.last_ran_on, no_of_orders: @distributor_missed_pincode.no_of_orders, pincode: @distributor_missed_pincode.pincode, total_value: @distributor_missed_pincode.total_value }
    end

    assert_redirected_to distributor_missed_pincode_path(assigns(:distributor_missed_pincode))
  end

  test "should show distributor_missed_pincode" do
    get :show, id: @distributor_missed_pincode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_missed_pincode
    assert_response :success
  end

  test "should update distributor_missed_pincode" do
    patch :update, id: @distributor_missed_pincode, distributor_missed_pincode: { description: @distributor_missed_pincode.description, last_ran_on: @distributor_missed_pincode.last_ran_on, no_of_orders: @distributor_missed_pincode.no_of_orders, pincode: @distributor_missed_pincode.pincode, total_value: @distributor_missed_pincode.total_value }
    assert_redirected_to distributor_missed_pincode_path(assigns(:distributor_missed_pincode))
  end

  test "should destroy distributor_missed_pincode" do
    assert_difference('DistributorMissedPincode.count', -1) do
      delete :destroy, id: @distributor_missed_pincode
    end

    assert_redirected_to distributor_missed_pincodes_path
  end
end
