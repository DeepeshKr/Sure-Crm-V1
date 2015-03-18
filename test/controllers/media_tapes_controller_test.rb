require 'test_helper'

class MediaTapesControllerTest < ActionController::TestCase
  setup do
    @media_tape = media_tapes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_tapes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_tape" do
    assert_difference('MediaTape.count') do
      post :create, media_tape: { description: @media_tape.description, duration_secs: @media_tape.duration_secs, media_id: @media_tape.media_id, name: @media_tape.name, product_variant_id: @media_tape.product_variant_id, tape_ext_ref_id: @media_tape.tape_ext_ref_id, unique_tape_name: @media_tape.unique_tape_name }
    end

    assert_redirected_to media_tape_path(assigns(:media_tape))
  end

  test "should show media_tape" do
    get :show, id: @media_tape
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @media_tape
    assert_response :success
  end

  test "should update media_tape" do
    patch :update, id: @media_tape, media_tape: { description: @media_tape.description, duration_secs: @media_tape.duration_secs, media_id: @media_tape.media_id, name: @media_tape.name, product_variant_id: @media_tape.product_variant_id, tape_ext_ref_id: @media_tape.tape_ext_ref_id, unique_tape_name: @media_tape.unique_tape_name }
    assert_redirected_to media_tape_path(assigns(:media_tape))
  end

  test "should destroy media_tape" do
    assert_difference('MediaTape.count', -1) do
      delete :destroy, id: @media_tape
    end

    assert_redirected_to media_tapes_path
  end
end
