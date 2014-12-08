require 'test_helper'

class CorporatesControllerTest < ActionController::TestCase
  setup do
    @corporate = corporates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:corporates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create corporate" do
    assert_difference('Corporate.count') do
      post :create, corporate: { address1: @corporate.address1, address2: @corporate.address2, address3: @corporate.address3, city: @corporate.city, country: @corporate.country, description: @corporate.description, designation1: @corporate.designation1, designation2: @corporate.designation2, designation3: @corporate.designation3, district: @corporate.district, emaild1: @corporate.emaild1, emailid2: @corporate.emailid2, emailid3: @corporate.emailid3, fax: @corporate.fax, first_name1: @corporate.first_name1, first_name2: @corporate.first_name2, first_name3: @corporate.first_name3, landmark: @corporate.landmark, last_name1: @corporate.last_name1, last_name2: @corporate.last_name2, last_name3: @corporate.last_name3, mobile1: @corporate.mobile1, mobile2: @corporate.mobile2, mobile3: @corporate.mobile3, name: @corporate.name, pincode: @corporate.pincode, salute1: @corporate.salute1, salute2: @corporate.salute2, salute3: @corporate.salute3, state: @corporate.state, telephone1: @corporate.telephone1, telephone2: @corporate.telephone2, website: @corporate.website }
    end

    assert_redirected_to corporate_path(assigns(:corporate))
  end

  test "should show corporate" do
    get :show, id: @corporate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @corporate
    assert_response :success
  end

  test "should update corporate" do
    patch :update, id: @corporate, corporate: { address1: @corporate.address1, address2: @corporate.address2, address3: @corporate.address3, city: @corporate.city, country: @corporate.country, description: @corporate.description, designation1: @corporate.designation1, designation2: @corporate.designation2, designation3: @corporate.designation3, district: @corporate.district, emaild1: @corporate.emaild1, emailid2: @corporate.emailid2, emailid3: @corporate.emailid3, fax: @corporate.fax, first_name1: @corporate.first_name1, first_name2: @corporate.first_name2, first_name3: @corporate.first_name3, landmark: @corporate.landmark, last_name1: @corporate.last_name1, last_name2: @corporate.last_name2, last_name3: @corporate.last_name3, mobile1: @corporate.mobile1, mobile2: @corporate.mobile2, mobile3: @corporate.mobile3, name: @corporate.name, pincode: @corporate.pincode, salute1: @corporate.salute1, salute2: @corporate.salute2, salute3: @corporate.salute3, state: @corporate.state, telephone1: @corporate.telephone1, telephone2: @corporate.telephone2, website: @corporate.website }
    assert_redirected_to corporate_path(assigns(:corporate))
  end

  test "should destroy corporate" do
    assert_difference('Corporate.count', -1) do
      delete :destroy, id: @corporate
    end

    assert_redirected_to corporates_path
  end
end
