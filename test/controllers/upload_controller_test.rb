require 'test_helper'

class UploadControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get salvar" do
    get :salvar
    assert_response :success
  end

  test "should get download" do
    get :download
    assert_response :success
  end

  test "should get remove_arquivo" do
    get :remove_arquivo
    assert_response :success
  end

end
