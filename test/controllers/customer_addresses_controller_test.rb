require 'test_helper'

class CustomerAddressesControllerTest < ActionController::TestCase
  setup do
    @customer_address = customer_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_address" do
    assert_difference('CustomerAddress.count') do
      post :create, customer_address: { address1: @customer_address.address1, address2: @customer_address.address2, address3: @customer_address.address3, city: @customer_address.city, country: @customer_address.country, customer_id: @customer_address.customer_id, description: @customer_address.description, district: @customer_address.district, fax: @customer_address.fax, landmark: @customer_address.landmark, name: @customer_address.name, pincode: @customer_address.pincode, state: @customer_address.state, telephone1: @customer_address.telephone1, telephone2: @customer_address.telephone2, valid_id: @customer_address.valid_id }
    end

    assert_redirected_to customer_address_path(assigns(:customer_address))
  end

  test "should show customer_address" do
    get :show, id: @customer_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_address
    assert_response :success
  end

  test "should update customer_address" do
    patch :update, id: @customer_address, customer_address: { address1: @customer_address.address1, address2: @customer_address.address2, address3: @customer_address.address3, city: @customer_address.city, country: @customer_address.country, customer_id: @customer_address.customer_id, description: @customer_address.description, district: @customer_address.district, fax: @customer_address.fax, landmark: @customer_address.landmark, name: @customer_address.name, pincode: @customer_address.pincode, state: @customer_address.state, telephone1: @customer_address.telephone1, telephone2: @customer_address.telephone2, valid_id: @customer_address.valid_id }
    assert_redirected_to customer_address_path(assigns(:customer_address))
  end

  test "should destroy customer_address" do
    assert_difference('CustomerAddress.count', -1) do
      delete :destroy, id: @customer_address
    end

    assert_redirected_to customer_addresses_path
  end
end
