require 'test_helper'

class FatToFitEmailStatusesControllerTest < ActionController::TestCase
  setup do
    @fat_to_fit_email_status = fat_to_fit_email_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fat_to_fit_email_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fat_to_fit_email_status" do
    assert_difference('FatToFitEmailStatus.count') do
      post :create, fat_to_fit_email_status: { emailid: @fat_to_fit_email_status.emailid, full_name: @fat_to_fit_email_status.full_name, last_ran_date: @fat_to_fit_email_status.last_ran_date, order_id: @fat_to_fit_email_status.order_id, order_no: @fat_to_fit_email_status.order_no, products: @fat_to_fit_email_status.products, send_status: @fat_to_fit_email_status.send_status }
    end

    assert_redirected_to fat_to_fit_email_status_path(assigns(:fat_to_fit_email_status))
  end

  test "should show fat_to_fit_email_status" do
    get :show, id: @fat_to_fit_email_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fat_to_fit_email_status
    assert_response :success
  end

  test "should update fat_to_fit_email_status" do
    patch :update, id: @fat_to_fit_email_status, fat_to_fit_email_status: { emailid: @fat_to_fit_email_status.emailid, full_name: @fat_to_fit_email_status.full_name, last_ran_date: @fat_to_fit_email_status.last_ran_date, order_id: @fat_to_fit_email_status.order_id, order_no: @fat_to_fit_email_status.order_no, products: @fat_to_fit_email_status.products, send_status: @fat_to_fit_email_status.send_status }
    assert_redirected_to fat_to_fit_email_status_path(assigns(:fat_to_fit_email_status))
  end

  test "should destroy fat_to_fit_email_status" do
    assert_difference('FatToFitEmailStatus.count', -1) do
      delete :destroy, id: @fat_to_fit_email_status
    end

    assert_redirected_to fat_to_fit_email_statuses_path
  end
end
