require 'test_helper'

class InteractionUsersControllerTest < ActionController::TestCase
  setup do
    @interaction_user = interaction_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_user" do
    assert_difference('InteractionUser.count') do
      post :create, interaction_user: { name: @interaction_user.name }
    end

    assert_redirected_to interaction_user_path(assigns(:interaction_user))
  end

  test "should show interaction_user" do
    get :show, id: @interaction_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_user
    assert_response :success
  end

  test "should update interaction_user" do
    patch :update, id: @interaction_user, interaction_user: { name: @interaction_user.name }
    assert_redirected_to interaction_user_path(assigns(:interaction_user))
  end

  test "should destroy interaction_user" do
    assert_difference('InteractionUser.count', -1) do
      delete :destroy, id: @interaction_user
    end

    assert_redirected_to interaction_users_path
  end
end
