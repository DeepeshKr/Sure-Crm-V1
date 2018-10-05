require 'test_helper'

class SalesReportPayUStepsControllerTest < ActionController::TestCase
  setup do
    @sales_report_pay_u_step = sales_report_pay_u_steps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_report_pay_u_steps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_report_pay_u_step" do
    assert_difference('SalesReportPayUStep.count') do
      post :create, sales_report_pay_u_step: { active: @sales_report_pay_u_step.active, description: @sales_report_pay_u_step.description, max_value: @sales_report_pay_u_step.max_value, min_value: @sales_report_pay_u_step.min_value, name: @sales_report_pay_u_step.name }
    end

    assert_redirected_to sales_report_pay_u_step_path(assigns(:sales_report_pay_u_step))
  end

  test "should show sales_report_pay_u_step" do
    get :show, id: @sales_report_pay_u_step
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_report_pay_u_step
    assert_response :success
  end

  test "should update sales_report_pay_u_step" do
    patch :update, id: @sales_report_pay_u_step, sales_report_pay_u_step: { active: @sales_report_pay_u_step.active, description: @sales_report_pay_u_step.description, max_value: @sales_report_pay_u_step.max_value, min_value: @sales_report_pay_u_step.min_value, name: @sales_report_pay_u_step.name }
    assert_redirected_to sales_report_pay_u_step_path(assigns(:sales_report_pay_u_step))
  end

  test "should destroy sales_report_pay_u_step" do
    assert_difference('SalesReportPayUStep.count', -1) do
      delete :destroy, id: @sales_report_pay_u_step
    end

    assert_redirected_to sales_report_pay_u_steps_path
  end
end
