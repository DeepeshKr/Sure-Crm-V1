require 'test_helper'

class DispatchCallStatusesControllerTest < ActionController::TestCase
  setup do
    @dispatch_call_status = dispatch_call_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dispatch_call_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dispatch_call_status" do
    assert_difference('DispatchCallStatus.count') do
      post :create, dispatch_call_status: { description: @dispatch_call_status.description, name: @dispatch_call_status.name, sort_order: @dispatch_call_status.sort_order }
    end

    assert_redirected_to dispatch_call_status_path(assigns(:dispatch_call_status))
  end

  test "should show dispatch_call_status" do
    get :show, id: @dispatch_call_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dispatch_call_status
    assert_response :success
  end

  test "should update dispatch_call_status" do
    patch :update, id: @dispatch_call_status, dispatch_call_status: { description: @dispatch_call_status.description, name: @dispatch_call_status.name, sort_order: @dispatch_call_status.sort_order }
    assert_redirected_to dispatch_call_status_path(assigns(:dispatch_call_status))
  end

  test "should destroy dispatch_call_status" do
    assert_difference('DispatchCallStatus.count', -1) do
      delete :destroy, id: @dispatch_call_status
    end

    assert_redirected_to dispatch_call_statuses_path
  end
end
