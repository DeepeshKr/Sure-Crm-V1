require 'test_helper'

class SalesIncentivesControllerTest < ActionController::TestCase
  setup do
    @sales_incentive = sales_incentives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_incentives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_incentive" do
    assert_difference('SalesIncentive.count') do
      post :create, sales_incentive: { commission: @sales_incentive.commission, description: @sales_incentive.description, max_value: @sales_incentive.max_value, min_value: @sales_incentive.min_value, name: @sales_incentive.name, no_of: @sales_incentive.no_of }
    end

    assert_redirected_to sales_incentive_path(assigns(:sales_incentive))
  end

  test "should show sales_incentive" do
    get :show, id: @sales_incentive
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_incentive
    assert_response :success
  end

  test "should update sales_incentive" do
    patch :update, id: @sales_incentive, sales_incentive: { commission: @sales_incentive.commission, description: @sales_incentive.description, max_value: @sales_incentive.max_value, min_value: @sales_incentive.min_value, name: @sales_incentive.name, no_of: @sales_incentive.no_of }
    assert_redirected_to sales_incentive_path(assigns(:sales_incentive))
  end

  test "should destroy sales_incentive" do
    assert_difference('SalesIncentive.count', -1) do
      delete :destroy, id: @sales_incentive
    end

    assert_redirected_to sales_incentives_path
  end
end
