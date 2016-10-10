require 'test_helper'

class SalesPpoEmailAlertsControllerTest < ActionController::TestCase
  setup do
    @sales_ppo_email_alert = sales_ppo_email_alerts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_ppo_email_alerts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_ppo_email_alert" do
    assert_difference('SalesPpoEmailAlert.count') do
      post :create, sales_ppo_email_alert: { email_id: @sales_ppo_email_alert.email_id, last_delivered_on: @sales_ppo_email_alert.last_delivered_on }
    end

    assert_redirected_to sales_ppo_email_alert_path(assigns(:sales_ppo_email_alert))
  end

  test "should show sales_ppo_email_alert" do
    get :show, id: @sales_ppo_email_alert
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_ppo_email_alert
    assert_response :success
  end

  test "should update sales_ppo_email_alert" do
    patch :update, id: @sales_ppo_email_alert, sales_ppo_email_alert: { email_id: @sales_ppo_email_alert.email_id, last_delivered_on: @sales_ppo_email_alert.last_delivered_on }
    assert_redirected_to sales_ppo_email_alert_path(assigns(:sales_ppo_email_alert))
  end

  test "should destroy sales_ppo_email_alert" do
    assert_difference('SalesPpoEmailAlert.count', -1) do
      delete :destroy, id: @sales_ppo_email_alert
    end

    assert_redirected_to sales_ppo_email_alerts_path
  end
end
