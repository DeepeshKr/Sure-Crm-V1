require 'test_helper'

class ProductStockAdjustsControllerTest < ActionController::TestCase
  setup do
    @product_stock_adjust = product_stock_adjusts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_stock_adjusts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_stock_adjust" do
    assert_difference('ProductStockAdjust.count') do
      post :create, product_stock_adjust: { barcode: @product_stock_adjust.barcode, change_stock: @product_stock_adjust.change_stock, created_date: @product_stock_adjust.created_date, description: @product_stock_adjust.description, emp_code: @product_stock_adjust.emp_code, emp_id: @product_stock_adjust.emp_id, ext_prod_code: @product_stock_adjust.ext_prod_code, name: @product_stock_adjust.name, product_list_id: @product_stock_adjust.product_list_id, product_master_id: @product_stock_adjust.product_master_id }
    end

    assert_redirected_to product_stock_adjust_path(assigns(:product_stock_adjust))
  end

  test "should show product_stock_adjust" do
    get :show, id: @product_stock_adjust
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_stock_adjust
    assert_response :success
  end

  test "should update product_stock_adjust" do
    patch :update, id: @product_stock_adjust, product_stock_adjust: { barcode: @product_stock_adjust.barcode, change_stock: @product_stock_adjust.change_stock, created_date: @product_stock_adjust.created_date, description: @product_stock_adjust.description, emp_code: @product_stock_adjust.emp_code, emp_id: @product_stock_adjust.emp_id, ext_prod_code: @product_stock_adjust.ext_prod_code, name: @product_stock_adjust.name, product_list_id: @product_stock_adjust.product_list_id, product_master_id: @product_stock_adjust.product_master_id }
    assert_redirected_to product_stock_adjust_path(assigns(:product_stock_adjust))
  end

  test "should destroy product_stock_adjust" do
    assert_difference('ProductStockAdjust.count', -1) do
      delete :destroy, id: @product_stock_adjust
    end

    assert_redirected_to product_stock_adjusts_path
  end
end
