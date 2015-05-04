require 'test_helper'

class MediaTapeHeadsControllerTest < ActionController::TestCase
  setup do
    @media_tape_head = media_tape_heads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_tape_heads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_tape_head" do
    assert_difference('MediaTapeHead.count') do
      post :create, media_tape_head: { description: @media_tape_head.description, name: @media_tape_head.name }
    end

    assert_redirected_to media_tape_head_path(assigns(:media_tape_head))
  end

  test "should show media_tape_head" do
    get :show, id: @media_tape_head
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_tape_head
    assert_response :success
  end

  test "should update media_tape_head" do
    patch :update, id: @media_tape_head, media_tape_head: { description: @media_tape_head.description, name: @media_tape_head.name }
    assert_redirected_to media_tape_head_path(assigns(:media_tape_head))
  end

  test "should destroy media_tape_head" do
    assert_difference('MediaTapeHead.count', -1) do
      delete :destroy, id: @media_tape_head
    end

    assert_redirected_to media_tape_heads_path
  end
end
