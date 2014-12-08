require 'test_helper'

class InteractionStatusesControllerTest < ActionController::TestCase
  setup do
    @interaction_status = interaction_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interaction_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interaction_status" do
    assert_difference('InteractionStatus.count') do
      post :create, interaction_status: { customer_description: @interaction_status.customer_description, internal_description: @interaction_status.internal_description, sortorder: @interaction_status.sortorder }
    end

    assert_redirected_to interaction_status_path(assigns(:interaction_status))
  end

  test "should show interaction_status" do
    get :show, id: @interaction_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interaction_status
    assert_response :success
  end

  test "should update interaction_status" do
    patch :update, id: @interaction_status, interaction_status: { customer_description: @interaction_status.customer_description, internal_description: @interaction_status.internal_description, sortorder: @interaction_status.sortorder }
    assert_redirected_to interaction_status_path(assigns(:interaction_status))
  end

  test "should destroy interaction_status" do
    assert_difference('InteractionStatus.count', -1) do
      delete :destroy, id: @interaction_status
    end

    assert_redirected_to interaction_statuses_path
  end
end
