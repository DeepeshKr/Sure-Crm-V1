require 'test_helper'

class IndiaCityListsControllerTest < ActionController::TestCase
  setup do
    @india_city_list = india_city_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:india_city_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create india_city_list" do
    assert_difference('IndiaCityList.count') do
      post :create, india_city_list: { name: @india_city_list.name, state: @india_city_list.state }
    end

    assert_redirected_to india_city_list_path(assigns(:india_city_list))
  end

  test "should show india_city_list" do
    get :show, id: @india_city_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @india_city_list
    assert_response :success
  end

  test "should update india_city_list" do
    patch :update, id: @india_city_list, india_city_list: { name: @india_city_list.name, state: @india_city_list.state }
    assert_redirected_to india_city_list_path(assigns(:india_city_list))
  end

  test "should destroy india_city_list" do
    assert_difference('IndiaCityList.count', -1) do
      delete :destroy, id: @india_city_list
    end

    assert_redirected_to india_city_lists_path
  end
end
