require 'test_helper'

class PackagesControllerTest < ActionController::TestCase
  setup do
    gift = packages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gifts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gift" do
    assert_difference('Gift.count') do
      post :create, gift: {  }
    end

    assert_redirected_to package_path(assigns(:gift))
  end

  test "should show gift" do
    get :show, id: gift
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: gift
    assert_response :success
  end

  test "should update gift" do
    patch :update, id: gift, gift: {  }
    assert_redirected_to package_path(assigns(:gift))
  end

  test "should destroy gift" do
    assert_difference('Gift.count', -1) do
      delete :destroy, id: gift
    end

    assert_redirected_to packages_path
  end
end
