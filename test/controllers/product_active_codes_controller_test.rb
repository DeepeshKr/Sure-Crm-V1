require 'test_helper'

class ProductActiveCodesControllerTest < ActionController::TestCase
  setup do
    @product_active_code = product_active_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_active_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_active_code" do
    assert_difference('ProductActiveCode.count') do
      post :create, product_active_code: { name: @product_active_code.name, sortorder: @product_active_code.sortorder }
    end

    assert_redirected_to product_active_code_path(assigns(:product_active_code))
  end

  test "should show product_active_code" do
    get :show, id: @product_active_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_active_code
    assert_response :success
  end

  test "should update product_active_code" do
    patch :update, id: @product_active_code, product_active_code: { name: @product_active_code.name, sortorder: @product_active_code.sortorder }
    assert_redirected_to product_active_code_path(assigns(:product_active_code))
  end

  test "should destroy product_active_code" do
    assert_difference('ProductActiveCode.count', -1) do
      delete :destroy, id: @product_active_code
    end

    assert_redirected_to product_active_codes_path
  end
end
