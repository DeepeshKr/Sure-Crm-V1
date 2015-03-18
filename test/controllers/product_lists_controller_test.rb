require 'test_helper'

class ProductListsControllerTest < ActionController::TestCase
  setup do
    @product_list = product_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_list" do
    assert_difference('ProductList.count') do
      post :create, product_list: { extproductcode: @product_list.extproductcode, list_barcode: @product_list.list_barcode, product_spec_list_id: @product_list.product_spec_list_id, product_variant_id: @product_list.product_variant_id }
    end

    assert_redirected_to product_list_path(assigns(:product_list))
  end

  test "should show product_list" do
    get :show, id: @product_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_list
    assert_response :success
  end

  test "should update product_list" do
    patch :update, id: @product_list, product_list: { extproductcode: @product_list.extproductcode, list_barcode: @product_list.list_barcode, product_spec_list_id: @product_list.product_spec_list_id, product_variant_id: @product_list.product_variant_id }
    assert_redirected_to product_list_path(assigns(:product_list))
  end

  test "should destroy product_list" do
    assert_difference('ProductList.count', -1) do
      delete :destroy, id: @product_list
    end

    assert_redirected_to product_lists_path
  end
end
