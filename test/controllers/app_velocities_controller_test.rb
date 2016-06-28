require 'test_helper'

class AppVelocitiesControllerTest < ActionController::TestCase
  setup do
    @app_velocity = app_velocities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_velocities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_velocity" do
    assert_difference('AppVelocity.count') do
      post :create, app_velocity: { description: @app_velocity.description, name: @app_velocity.name, priority_no: @app_velocity.priority_no }
    end

    assert_redirected_to app_velocity_path(assigns(:app_velocity))
  end

  test "should show app_velocity" do
    get :show, id: @app_velocity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_velocity
    assert_response :success
  end

  test "should update app_velocity" do
    patch :update, id: @app_velocity, app_velocity: { description: @app_velocity.description, name: @app_velocity.name, priority_no: @app_velocity.priority_no }
    assert_redirected_to app_velocity_path(assigns(:app_velocity))
  end

  test "should destroy app_velocity" do
    assert_difference('AppVelocity.count', -1) do
      delete :destroy, id: @app_velocity
    end

    assert_redirected_to app_velocities_path
  end
end
