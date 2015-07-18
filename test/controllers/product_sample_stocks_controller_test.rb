require 'test_helper'

class ProductSampleStocksControllerTest < ActionController::TestCase
  setup do
    @product_sample_stock = product_sample_stocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_sample_stocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_sample_stock" do
    assert_difference('ProductSampleStock.count') do
      post :create, product_sample_stock: { air_date: @product_sample_stock.air_date, barcode: @product_sample_stock.barcode, basic_price: @product_sample_stock.basic_price, description: @product_sample_stock.description, orders: @product_sample_stock.orders, prod_code: @product_sample_stock.prod_code, product_list_id: @product_sample_stock.product_list_id, product_master_id: @product_sample_stock.product_master_id, product_name: @product_sample_stock.product_name, shipping: @product_sample_stock.shipping, stock: @product_sample_stock.stock }
    end

    assert_redirected_to product_sample_stock_path(assigns(:product_sample_stock))
  end

  test "should show product_sample_stock" do
    get :show, id: @product_sample_stock
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_sample_stock
    assert_response :success
  end

  test "should update product_sample_stock" do
    patch :update, id: @product_sample_stock, product_sample_stock: { air_date: @product_sample_stock.air_date, barcode: @product_sample_stock.barcode, basic_price: @product_sample_stock.basic_price, description: @product_sample_stock.description, orders: @product_sample_stock.orders, prod_code: @product_sample_stock.prod_code, product_list_id: @product_sample_stock.product_list_id, product_master_id: @product_sample_stock.product_master_id, product_name: @product_sample_stock.product_name, shipping: @product_sample_stock.shipping, stock: @product_sample_stock.stock }
    assert_redirected_to product_sample_stock_path(assigns(:product_sample_stock))
  end

  test "should destroy product_sample_stock" do
    assert_difference('ProductSampleStock.count', -1) do
      delete :destroy, id: @product_sample_stock
    end

    assert_redirected_to product_sample_stocks_path
  end
end
