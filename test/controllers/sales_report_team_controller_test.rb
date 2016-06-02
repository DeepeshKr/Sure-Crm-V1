require 'test_helper'

class SalesReportTeamControllerTest < ActionController::TestCase
  test "should get show_wise" do
    get :show_wise
    assert_response :success
  end

  test "should get agent_order" do
    get :agent_order
    assert_response :success
  end

  test "should get pay_u_orders" do
    get :pay_u_orders
    assert_response :success
  end

end
