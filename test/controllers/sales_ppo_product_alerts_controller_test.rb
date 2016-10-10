require 'test_helper'

class SalesPpoProductAlertsControllerTest < ActionController::TestCase
  setup do
    @sales_ppo_product_alert = sales_ppo_product_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_ppo_product_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_ppo_product_alert" do
    assert_difference('SalesPpoProductAlert.count') do
      post :create, sales_ppo_product_alert: { product_list_id: @sales_ppo_product_alert.product_list_id }
    end

    assert_redirected_to sales_ppo_product_alert_path(assigns(:sales_ppo_product_alert))
  end

  test "should show sales_ppo_product_alert" do
    get :show, id: @sales_ppo_product_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_ppo_product_alert
    assert_response :success
  end

  test "should update sales_ppo_product_alert" do
    patch :update, id: @sales_ppo_product_alert, sales_ppo_product_alert: { product_list_id: @sales_ppo_product_alert.product_list_id }
    assert_redirected_to sales_ppo_product_alert_path(assigns(:sales_ppo_product_alert))
  end

  test "should destroy sales_ppo_product_alert" do
    assert_difference('SalesPpoProductAlert.count', -1) do
      delete :destroy, id: @sales_ppo_product_alert
    end

    assert_redirected_to sales_ppo_product_alerts_path
  end
end
