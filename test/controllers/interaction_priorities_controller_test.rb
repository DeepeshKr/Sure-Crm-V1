require 'test_helper'

class InteractionPrioritiesControllerTest < ActionController::TestCase
  setup do
    @interaction_priority = interaction_priorities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_priorities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_priority" do
    assert_difference('InteractionPriority.count') do
      post :create, interaction_priority: { name: @interaction_priority.name, sortorder: @interaction_priority.sortorder }
    end

    assert_redirected_to interaction_priority_path(assigns(:interaction_priority))
  end

  test "should show interaction_priority" do
    get :show, id: @interaction_priority
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_priority
    assert_response :success
  end

  test "should update interaction_priority" do
    patch :update, id: @interaction_priority, interaction_priority: { name: @interaction_priority.name, sortorder: @interaction_priority.sortorder }
    assert_redirected_to interaction_priority_path(assigns(:interaction_priority))
  end

  test "should destroy interaction_priority" do
    assert_difference('InteractionPriority.count', -1) do
      delete :destroy, id: @interaction_priority
    end

    assert_redirected_to interaction_priorities_path
  end
end
