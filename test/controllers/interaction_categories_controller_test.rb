require 'test_helper'

class InteractionCategoriesControllerTest < ActionController::TestCase
  setup do
    @interaction_category = interaction_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_category" do
    assert_difference('InteractionCategory.count') do
      post :create, interaction_category: { employeeid: @interaction_category.employeeid, name: @interaction_category.name, resolutionhours: @interaction_category.resolutionhours, sortorder: @interaction_category.sortorder }
    end

    assert_redirected_to interaction_category_path(assigns(:interaction_category))
  end

  test "should show interaction_category" do
    get :show, id: @interaction_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_category
    assert_response :success
  end

  test "should update interaction_category" do
    patch :update, id: @interaction_category, interaction_category: { employeeid: @interaction_category.employeeid, name: @interaction_category.name, resolutionhours: @interaction_category.resolutionhours, sortorder: @interaction_category.sortorder }
    assert_redirected_to interaction_category_path(assigns(:interaction_category))
  end

  test "should destroy interaction_category" do
    assert_difference('InteractionCategory.count', -1) do
      delete :destroy, id: @interaction_category
    end

    assert_redirected_to interaction_categories_path
  end
end
