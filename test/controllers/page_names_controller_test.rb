require 'test_helper'

class PageNamesControllerTest < ActionController::TestCase
  setup do
    @page_name = page_names(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_name" do
    assert_difference('PageName.count') do
      post :create, page_name: { description: @page_name.description, name: @page_name.name, sort_order: @page_name.sort_order }
    end

    assert_redirected_to page_name_path(assigns(:page_name))
  end

  test "should show page_name" do
    get :show, id: @page_name
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_name
    assert_response :success
  end

  test "should update page_name" do
    patch :update, id: @page_name, page_name: { description: @page_name.description, name: @page_name.name, sort_order: @page_name.sort_order }
    assert_redirected_to page_name_path(assigns(:page_name))
  end

  test "should destroy page_name" do
    assert_difference('PageName.count', -1) do
      delete :destroy, id: @page_name
    end

    assert_redirected_to page_names_path
  end
end
