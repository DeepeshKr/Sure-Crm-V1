require 'test_helper'

class AppFeatureRequestsControllerTest < ActionController::TestCase
  setup do
    @app_feature_request = app_feature_requests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:app_feature_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create app_feature_request" do
    assert_difference('AppFeatureRequest.count') do
      post :create, app_feature_request: { actual_completion_date: @app_feature_request.actual_completion_date, actual_hours: @app_feature_request.actual_hours, app_feature_type_id: @app_feature_request.app_feature_type_id, app_id: @app_feature_request.app_id, assigned_to: @app_feature_request.assigned_to, bug_count: @app_feature_request.bug_count, comment_count: @app_feature_request.comment_count, current_status_id: @app_feature_request.current_status_id, estimated_completion_date: @app_feature_request.estimated_completion_date, estimated_hours: @app_feature_request.estimated_hours, extra_notes: @app_feature_request.extra_notes, linked_app_feature_id: @app_feature_request.linked_app_feature_id, mandatory_requirements: @app_feature_request.mandatory_requirements, name: @app_feature_request.name, priority_id: @app_feature_request.priority_id, problem_this_solves: @app_feature_request.problem_this_solves, queue_no: @app_feature_request.queue_no, request_by: @app_feature_request.request_by, require_by_date: @app_feature_request.require_by_date, tables_used: @app_feature_request.tables_used, technical_notes: @app_feature_request.technical_notes, user_approved_date: @app_feature_request.user_approved_date, user_satisfaction_level_id: @app_feature_request.user_satisfaction_level_id, velocity_id: @app_feature_request.velocity_id }
    end

    assert_redirected_to app_feature_request_path(assigns(:app_feature_request))
  end

  test "should show app_feature_request" do
    get :show, id: @app_feature_request
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @app_feature_request
    assert_response :success
  end

  test "should update app_feature_request" do
    patch :update, id: @app_feature_request, app_feature_request: { actual_completion_date: @app_feature_request.actual_completion_date, actual_hours: @app_feature_request.actual_hours, app_feature_type_id: @app_feature_request.app_feature_type_id, app_id: @app_feature_request.app_id, assigned_to: @app_feature_request.assigned_to, bug_count: @app_feature_request.bug_count, comment_count: @app_feature_request.comment_count, current_status_id: @app_feature_request.current_status_id, estimated_completion_date: @app_feature_request.estimated_completion_date, estimated_hours: @app_feature_request.estimated_hours, extra_notes: @app_feature_request.extra_notes, linked_app_feature_id: @app_feature_request.linked_app_feature_id, mandatory_requirements: @app_feature_request.mandatory_requirements, name: @app_feature_request.name, priority_id: @app_feature_request.priority_id, problem_this_solves: @app_feature_request.problem_this_solves, queue_no: @app_feature_request.queue_no, request_by: @app_feature_request.request_by, require_by_date: @app_feature_request.require_by_date, tables_used: @app_feature_request.tables_used, technical_notes: @app_feature_request.technical_notes, user_approved_date: @app_feature_request.user_approved_date, user_satisfaction_level_id: @app_feature_request.user_satisfaction_level_id, velocity_id: @app_feature_request.velocity_id }
    assert_redirected_to app_feature_request_path(assigns(:app_feature_request))
  end

  test "should destroy app_feature_request" do
    assert_difference('AppFeatureRequest.count', -1) do
      delete :destroy, id: @app_feature_request
    end

    assert_redirected_to app_feature_requests_path
  end
end
