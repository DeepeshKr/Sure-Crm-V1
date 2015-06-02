require 'test_helper'

class SalesPpoReportControllerTest < ActionController::TestCase
  test "should get summary" do
    get :summary
    assert_response :success
  end

  test "should get daily" do
    get :daily
    assert_response :success
  end

  test "should get hourly" do
    get :hourly
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get channel" do
    get :channel
    assert_response :success
  end

end
