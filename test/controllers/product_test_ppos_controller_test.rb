require 'test_helper'

class ProductTestPposControllerTest < ActionController::TestCase
  setup do
    @product_test_ppo = product_test_ppos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_test_ppos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_test_ppo" do
    assert_difference('ProductTestPpo.count') do
      post :create, product_test_ppo: { ad_cost: @product_test_ppo.ad_cost, aired_date: @product_test_ppo.aired_date, barcode: @product_test_ppo.barcode, basic_price: @product_test_ppo.basic_price, channel: @product_test_ppo.channel, description: @product_test_ppo.description, name: @product_test_ppo.name, orders: @product_test_ppo.orders, ppo: @product_test_ppo.ppo, prod_code: @product_test_ppo.prod_code, shipping: @product_test_ppo.shipping, slot: @product_test_ppo.slot }
    end

    assert_redirected_to product_test_ppo_path(assigns(:product_test_ppo))
  end

  test "should show product_test_ppo" do
    get :show, id: @product_test_ppo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_test_ppo
    assert_response :success
  end

  test "should update product_test_ppo" do
    patch :update, id: @product_test_ppo, product_test_ppo: { ad_cost: @product_test_ppo.ad_cost, aired_date: @product_test_ppo.aired_date, barcode: @product_test_ppo.barcode, basic_price: @product_test_ppo.basic_price, channel: @product_test_ppo.channel, description: @product_test_ppo.description, name: @product_test_ppo.name, orders: @product_test_ppo.orders, ppo: @product_test_ppo.ppo, prod_code: @product_test_ppo.prod_code, shipping: @product_test_ppo.shipping, slot: @product_test_ppo.slot }
    assert_redirected_to product_test_ppo_path(assigns(:product_test_ppo))
  end

  test "should destroy product_test_ppo" do
    assert_difference('ProductTestPpo.count', -1) do
      delete :destroy, id: @product_test_ppo
    end

    assert_redirected_to product_test_ppos_path
  end
end
