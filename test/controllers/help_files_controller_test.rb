require 'test_helper'

class HelpFilesControllerTest < ActionController::TestCase
  setup do
    @help_file = help_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:help_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create help_file" do
    assert_difference('HelpFile.count') do
      post :create, help_file: { code_used: @help_file.code_used, database_used: @help_file.database_used, description: @help_file.description, employee_id: @help_file.employee_id, link: @help_file.link, name: @help_file.name, tags: @help_file.tags }
    end

    assert_redirected_to help_file_path(assigns(:help_file))
  end

  test "should show help_file" do
    get :show, id: @help_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @help_file
    assert_response :success
  end

  test "should update help_file" do
    patch :update, id: @help_file, help_file: { code_used: @help_file.code_used, database_used: @help_file.database_used, description: @help_file.description, employee_id: @help_file.employee_id, link: @help_file.link, name: @help_file.name, tags: @help_file.tags }
    assert_redirected_to help_file_path(assigns(:help_file))
  end

  test "should destroy help_file" do
    assert_difference('HelpFile.count', -1) do
      delete :destroy, id: @help_file
    end

    assert_redirected_to help_files_path
  end
end
