require 'test_helper'

class ReturnRatesControllerTest < ActionController::TestCase
  setup do
    @return_rate = return_rates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:return_rates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create return_rate" do
    assert_difference('ReturnRate.count') do
      post :create, return_rate: { cancelled: @return_rate.cancelled, name: @return_rate.name, no_of_days: @return_rate.no_of_days, paid: @return_rate.paid, returned: @return_rate.returned, sort_order: @return_rate.sort_order, total: @return_rate.total, transfer_cancelled: @return_rate.transfer_cancelled, transfer_paid: @return_rate.transfer_paid, transfer_total: @return_rate.transfer_total }
    end

    assert_redirected_to return_rate_path(assigns(:return_rate))
  end

  test "should show return_rate" do
    get :show, id: @return_rate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @return_rate
    assert_response :success
  end

  test "should update return_rate" do
    patch :update, id: @return_rate, return_rate: { cancelled: @return_rate.cancelled, name: @return_rate.name, no_of_days: @return_rate.no_of_days, paid: @return_rate.paid, returned: @return_rate.returned, sort_order: @return_rate.sort_order, total: @return_rate.total, transfer_cancelled: @return_rate.transfer_cancelled, transfer_paid: @return_rate.transfer_paid, transfer_total: @return_rate.transfer_total }
    assert_redirected_to return_rate_path(assigns(:return_rate))
  end

  test "should destroy return_rate" do
    assert_difference('ReturnRate.count', -1) do
      delete :destroy, id: @return_rate
    end

    assert_redirected_to return_rates_path
  end
end
