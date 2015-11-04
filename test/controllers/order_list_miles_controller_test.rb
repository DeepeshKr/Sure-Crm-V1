require 'test_helper'

class OrderListMilesControllerTest < ActionController::TestCase
  setup do
    @order_list_mile = order_list_miles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:order_list_miles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order_list_mile" do
    assert_difference('OrderListMile.count') do
      post :create, order_list_mile: { description: @order_list_mile.description, name: @order_list_mile.name, sort_order: @order_list_mile.sort_order }
    end

    assert_redirected_to order_list_mile_path(assigns(:order_list_mile))
  end

  test "should show order_list_mile" do
    get :show, id: @order_list_mile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order_list_mile
    assert_response :success
  end

  test "should update order_list_mile" do
    patch :update, id: @order_list_mile, order_list_mile: { description: @order_list_mile.description, name: @order_list_mile.name, sort_order: @order_list_mile.sort_order }
    assert_redirected_to order_list_mile_path(assigns(:order_list_mile))
  end

  test "should destroy order_list_mile" do
    assert_difference('OrderListMile.count', -1) do
      delete :destroy, id: @order_list_mile
    end

    assert_redirected_to order_list_miles_path
  end
end
