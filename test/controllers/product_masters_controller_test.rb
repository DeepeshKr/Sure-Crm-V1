require 'test_helper'

class ProductMastersControllerTest < ActionController::TestCase
  setup do
    @product_master = product_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_master" do
    assert_difference('ProductMaster.count') do
      post :create, product_master: { barcode: @product_master.barcode, categoryid: @product_master.categoryid, description: @product_master.description, extproductcode: @product_master.extproductcode, inventoryid: @product_master.inventoryid, name: @product_master.name, price: @product_master.price, taxes: @product_master.taxes, total: @product_master.total }
    end

    assert_redirected_to product_master_path(assigns(:product_master))
  end

  test "should show product_master" do
    get :show, id: @product_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_master
    assert_response :success
  end

  test "should update product_master" do
    patch :update, id: @product_master, product_master: { barcode: @product_master.barcode, categoryid: @product_master.categoryid, description: @product_master.description, extproductcode: @product_master.extproductcode, inventoryid: @product_master.inventoryid, name: @product_master.name, price: @product_master.price, taxes: @product_master.taxes, total: @product_master.total }
    assert_redirected_to product_master_path(assigns(:product_master))
  end

  test "should destroy product_master" do
    assert_difference('ProductMaster.count', -1) do
      delete :destroy, id: @product_master
    end

    assert_redirected_to product_masters_path
  end
end
