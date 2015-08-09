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
      post :create, product_cost_master: { barcode: @product_cost_master.barcode, basic_cost: @product_cost_master.basic_cost, call_centre_commission: @product_cost_master.call_centre_commission, cost_of_return: @product_cost_master.cost_of_return, dealer_network_basic: @product_cost_master.dealer_network_basic, postage: @product_cost_master.postage, prod: @product_cost_master.prod, product_cost: @product_cost_master.product_cost, product_id: @product_cost_master.product_id, product_list_id: @product_cost_master.product_list_id, royalty: @product_cost_master.royalty, shipping_handling: @product_cost_master.shipping_handling, tel_cost: @product_cost_master.tel_cost, transf_order_basic: @product_cost_master.transf_order_basic, wholesale_variable_cost: @product_cost_master.wholesale_variable_cost }
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
    patch :update, id: @product_cost_master, product_cost_master: { barcode: @product_cost_master.barcode, basic_cost: @product_cost_master.basic_cost, call_centre_commission: @product_cost_master.call_centre_commission, cost_of_return: @product_cost_master.cost_of_return, dealer_network_basic: @product_cost_master.dealer_network_basic, postage: @product_cost_master.postage, prod: @product_cost_master.prod, product_cost: @product_cost_master.product_cost, product_id: @product_cost_master.product_id, product_list_id: @product_cost_master.product_list_id, royalty: @product_cost_master.royalty, shipping_handling: @product_cost_master.shipping_handling, tel_cost: @product_cost_master.tel_cost, transf_order_basic: @product_cost_master.transf_order_basic, wholesale_variable_cost: @product_cost_master.wholesale_variable_cost }
    assert_redirected_to product_cost_master_path(assigns(:product_cost_master))
  end

  test "should destroy product_cost_master" do
    assert_difference('ProductCostMaster.count', -1) do
      delete :destroy, id: @product_cost_master
    end

    assert_redirected_to product_cost_masters_path
  end
end
