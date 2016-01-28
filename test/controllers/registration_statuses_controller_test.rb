require 'test_helper'

class RegistrationStatusesControllerTest < ActionController::TestCase
  setup do
    @registration_status = registration_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_status" do
    assert_difference('RegistrationStatus.count') do
      post :create, registration_status: { description: @registration_status.description, name: @registration_status.name, sort_order: @registration_status.sort_order }
    end

    assert_redirected_to registration_status_path(assigns(:registration_status))
  end

  test "should show registration_status" do
    get :show, id: @registration_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration_status
    assert_response :success
  end

  test "should update registration_status" do
    patch :update, id: @registration_status, registration_status: { description: @registration_status.description, name: @registration_status.name, sort_order: @registration_status.sort_order }
    assert_redirected_to registration_status_path(assigns(:registration_status))
  end

  test "should destroy registration_status" do
    assert_difference('RegistrationStatus.count', -1) do
      delete :destroy, id: @registration_status
    end

    assert_redirected_to registration_statuses_path
  end
end
