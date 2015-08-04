require 'test_helper'

class ProductCostMastersControllerTest < ActionController::TestCase
  setup do
    @product_cost_master = product_cost_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_cost_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_cost_master" do
    assert_difference('ProductCostMaster.count') do
      post :create, product_cost_master: { barcode: @product_cost_master.barcode, cost: @product_cost_master.cost, prod: @product_cost_master.prod, product_id: @product_cost_master.product_id, revenue: @product_cost_master.revenue }
    end

    assert_redirected_to product_cost_master_path(assigns(:product_cost_master))
  end

  test "should show product_cost_master" do
    get :show, id: @product_cost_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_cost_master
    assert_response :success
  end

  test "should update product_cost_master" do
    patch :update, id: @product_cost_master, product_cost_master: { barcode: @product_cost_master.barcode, cost: @product_cost_master.cost, prod: @product_cost_master.prod, product_id: @product_cost_master.product_id, revenue: @product_cost_master.revenue }
    assert_redirected_to product_cost_master_path(assigns(:product_cost_master))
  end

  test "should destroy product_cost_master" do
    assert_difference('ProductCostMaster.count', -1) do
      delete :destroy, id: @product_cost_master
    end

    assert_redirected_to product_cost_masters_path
  end
end
