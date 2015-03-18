require 'test_helper'

class ProductSpecListsControllerTest < ActionController::TestCase
  setup do
    @product_spec_list = product_spec_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_spec_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_spec_list" do
    assert_difference('ProductSpecList.count') do
      post :create, product_spec_list: { description: @product_spec_list.description, name: @product_spec_list.name, spec_1: @product_spec_list.spec_1, spec_2: @product_spec_list.spec_2, spec_3: @product_spec_list.spec_3, spec_4: @product_spec_list.spec_4, spec_5: @product_spec_list.spec_5 }
    end

    assert_redirected_to product_spec_list_path(assigns(:product_spec_list))
  end

  test "should show product_spec_list" do
    get :show, id: @product_spec_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_spec_list
    assert_response :success
  end

  test "should update product_spec_list" do
    patch :update, id: @product_spec_list, product_spec_list: { description: @product_spec_list.description, name: @product_spec_list.name, spec_1: @product_spec_list.spec_1, spec_2: @product_spec_list.spec_2, spec_3: @product_spec_list.spec_3, spec_4: @product_spec_list.spec_4, spec_5: @product_spec_list.spec_5 }
    assert_redirected_to product_spec_list_path(assigns(:product_spec_list))
  end

  test "should destroy product_spec_list" do
    assert_difference('ProductSpecList.count', -1) do
      delete :destroy, id: @product_spec_list
    end

    assert_redirected_to product_spec_lists_path
  end
end
