require 'test_helper'

class DistributorUploadOrdersControllerTest < ActionController::TestCase
  setup do
    @distributor_upload_order = distributor_upload_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributor_upload_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create distributor_upload_order" do
    assert_difference('DistributorUploadOrder.count') do
      post :create, distributor_upload_order: { description: @distributor_upload_order.description, ext_order_id: @distributor_upload_order.ext_order_id, last_ran_on: @distributor_upload_order.last_ran_on, online_description: @distributor_upload_order.online_description, online_last_ran_on: @distributor_upload_order.online_last_ran_on, online_order_id: @distributor_upload_order.online_order_id, order_id: @distributor_upload_order.order_id }
    end

    assert_redirected_to distributor_upload_order_path(assigns(:distributor_upload_order))
  end

  test "should show distributor_upload_order" do
    get :show, id: @distributor_upload_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @distributor_upload_order
    assert_response :success
  end

  test "should update distributor_upload_order" do
    patch :update, id: @distributor_upload_order, distributor_upload_order: { description: @distributor_upload_order.description, ext_order_id: @distributor_upload_order.ext_order_id, last_ran_on: @distributor_upload_order.last_ran_on, online_description: @distributor_upload_order.online_description, online_last_ran_on: @distributor_upload_order.online_last_ran_on, online_order_id: @distributor_upload_order.online_order_id, order_id: @distributor_upload_order.order_id }
    assert_redirected_to distributor_upload_order_path(assigns(:distributor_upload_order))
  end

  test "should destroy distributor_upload_order" do
    assert_difference('DistributorUploadOrder.count', -1) do
      delete :destroy, id: @distributor_upload_order
    end

    assert_redirected_to distributor_upload_orders_path
  end
end
