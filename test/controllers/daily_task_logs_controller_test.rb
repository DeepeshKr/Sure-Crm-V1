require 'test_helper'

class DailyTaskLogsControllerTest < ActionController::TestCase
  setup do
    @daily_task_log = daily_task_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:daily_task_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create daily_task_log" do
    assert_difference('DailyTaskLog.count') do
      post :create, daily_task_log: { checked_by: @daily_task_log.checked_by, checked_on: @daily_task_log.checked_on, daily_task_id: @daily_task_log.daily_task_id, name: @daily_task_log.name, status: @daily_task_log.status, syntax_error: @daily_task_log.syntax_error }
    end

    assert_redirected_to daily_task_log_path(assigns(:daily_task_log))
  end

  test "should show daily_task_log" do
    get :show, id: @daily_task_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @daily_task_log
    assert_response :success
  end

  test "should update daily_task_log" do
    patch :update, id: @daily_task_log, daily_task_log: { checked_by: @daily_task_log.checked_by, checked_on: @daily_task_log.checked_on, daily_task_id: @daily_task_log.daily_task_id, name: @daily_task_log.name, status: @daily_task_log.status, syntax_error: @daily_task_log.syntax_error }
    assert_redirected_to daily_task_log_path(assigns(:daily_task_log))
  end

  test "should destroy daily_task_log" do
    assert_difference('DailyTaskLog.count', -1) do
      delete :destroy, id: @daily_task_log
    end

    assert_redirected_to daily_task_logs_path
  end
end
