require 'test_helper'

class ProductMasterAddOnsControllerTest < ActionController::TestCase
  setup do
    @product_master_add_on = product_master_add_ons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_master_add_ons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_master_add_on" do
    assert_difference('ProductMasterAddOn.count') do
      post :create, product_master_add_on: { activeid: @product_master_add_on.activeid, change_price: @product_master_add_on.change_price, product_list_id: @product_master_add_on.product_list_id, product_master_id: @product_master_add_on.product_master_id }
    end

    assert_redirected_to product_master_add_on_path(assigns(:product_master_add_on))
  end

  test "should show product_master_add_on" do
    get :show, id: @product_master_add_on
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_master_add_on
    assert_response :success
  end

  test "should update product_master_add_on" do
    patch :update, id: @product_master_add_on, product_master_add_on: { activeid: @product_master_add_on.activeid, change_price: @product_master_add_on.change_price, product_list_id: @product_master_add_on.product_list_id, product_master_id: @product_master_add_on.product_master_id }
    assert_redirected_to product_master_add_on_path(assigns(:product_master_add_on))
  end

  test "should destroy product_master_add_on" do
    assert_difference('ProductMasterAddOn.count', -1) do
      delete :destroy, id: @product_master_add_on
    end

    assert_redirected_to product_master_add_ons_path
  end
end
