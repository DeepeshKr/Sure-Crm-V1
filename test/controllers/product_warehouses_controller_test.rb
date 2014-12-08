require 'test_helper'

class ProductWarehousesControllerTest < ActionController::TestCase
  setup do
    @product_warehouse = product_warehouses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_warehouses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_warehouse" do
    assert_difference('ProductWarehouse.count') do
      post :create, product_warehouse: { address1: @product_warehouse.address1, address2: @product_warehouse.address2, address3: @product_warehouse.address3, city: @product_warehouse.city, country: @product_warehouse.country, description: @product_warehouse.description, emailid: @product_warehouse.emailid, fax: @product_warehouse.fax, landmark: @product_warehouse.landmark, location_name: @product_warehouse.location_name, pincode: @product_warehouse.pincode, state: @product_warehouse.state, telephone1: @product_warehouse.telephone1, telephone2: @product_warehouse.telephone2 }
    end

    assert_redirected_to product_warehouse_path(assigns(:product_warehouse))
  end

  test "should show product_warehouse" do
    get :show, id: @product_warehouse
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_warehouse
    assert_response :success
  end

  test "should update product_warehouse" do
    patch :update, id: @product_warehouse, product_warehouse: { address1: @product_warehouse.address1, address2: @product_warehouse.address2, address3: @product_warehouse.address3, city: @product_warehouse.city, country: @product_warehouse.country, description: @product_warehouse.description, emailid: @product_warehouse.emailid, fax: @product_warehouse.fax, landmark: @product_warehouse.landmark, location_name: @product_warehouse.location_name, pincode: @product_warehouse.pincode, state: @product_warehouse.state, telephone1: @product_warehouse.telephone1, telephone2: @product_warehouse.telephone2 }
    assert_redirected_to product_warehouse_path(assigns(:product_warehouse))
  end

  test "should destroy product_warehouse" do
    assert_difference('ProductWarehouse.count', -1) do
      delete :destroy, id: @product_warehouse
    end

    assert_redirected_to product_warehouses_path
  end
end
