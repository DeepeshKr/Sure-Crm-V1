require 'test_helper'

class PayumoneyStatusesControllerTest < ActionController::TestCase
  setup do
    @payumoney_status = payumoney_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payumoney_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payumoney_status" do
    assert_difference('PayumoneyStatus.count') do
      post :create, payumoney_status: { description: @payumoney_status.description, external_description: @payumoney_status.external_description, name: @payumoney_status.name, priority_no: @payumoney_status.priority_no, valid_payment: @payumoney_status.valid_payment }
    end

    assert_redirected_to payumoney_status_path(assigns(:payumoney_status))
  end

  test "should show payumoney_status" do
    get :show, id: @payumoney_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payumoney_status
    assert_response :success
  end

  test "should update payumoney_status" do
    patch :update, id: @payumoney_status, payumoney_status: { description: @payumoney_status.description, external_description: @payumoney_status.external_description, name: @payumoney_status.name, priority_no: @payumoney_status.priority_no, valid_payment: @payumoney_status.valid_payment }
    assert_redirected_to payumoney_status_path(assigns(:payumoney_status))
  end

  test "should destroy payumoney_status" do
    assert_difference('PayumoneyStatus.count', -1) do
      delete :destroy, id: @payumoney_status
    end

    assert_redirected_to payumoney_statuses_path
  end
end
