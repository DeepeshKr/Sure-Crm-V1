require 'test_helper'

class SalesUpsaleProductsControllerTest < ActionController::TestCase
  setup do
    @sales_upsale_product = sales_upsale_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_upsale_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_upsale_product" do
    assert_difference('SalesUpsaleProduct.count') do
      post :create, sales_upsale_product: { product_list_id: @sales_upsale_product.product_list_id }
    end

    assert_redirected_to sales_upsale_product_path(assigns(:sales_upsale_product))
  end

  test "should show sales_upsale_product" do
    get :show, id: @sales_upsale_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_upsale_product
    assert_response :success
  end

  test "should update sales_upsale_product" do
    patch :update, id: @sales_upsale_product, sales_upsale_product: { product_list_id: @sales_upsale_product.product_list_id }
    assert_redirected_to sales_upsale_product_path(assigns(:sales_upsale_product))
  end

  test "should destroy sales_upsale_product" do
    assert_difference('SalesUpsaleProduct.count', -1) do
      delete :destroy, id: @sales_upsale_product
    end

    assert_redirected_to sales_upsale_products_path
  end
end
