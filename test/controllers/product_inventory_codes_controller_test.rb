require 'test_helper'

class ProductInventoryCodesControllerTest < ActionController::TestCase
  setup do
    @product_inventory_code = product_inventory_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_inventory_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_inventory_code" do
    assert_difference('ProductInventoryCode.count') do
      post :create, product_inventory_code: { name: @product_inventory_code.name, sortorder: @product_inventory_code.sortorder }
    end

    assert_redirected_to product_inventory_code_path(assigns(:product_inventory_code))
  end

  test "should show product_inventory_code" do
    get :show, id: @product_inventory_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_inventory_code
    assert_response :success
  end

  test "should update product_inventory_code" do
    patch :update, id: @product_inventory_code, product_inventory_code: { name: @product_inventory_code.name, sortorder: @product_inventory_code.sortorder }
    assert_redirected_to product_inventory_code_path(assigns(:product_inventory_code))
  end

  test "should destroy product_inventory_code" do
    assert_difference('ProductInventoryCode.count', -1) do
      delete :destroy, id: @product_inventory_code
    end

    assert_redirected_to product_inventory_codes_path
  end
end
