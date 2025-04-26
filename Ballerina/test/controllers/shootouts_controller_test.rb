require "test_helper"

class ShootoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shootout = shootouts(:one)
  end

  test "should get index" do
    get shootouts_url
    assert_response :success
  end

  test "should get new" do
    get new_shootout_url
    assert_response :success
  end

  test "should create shootout" do
    assert_difference("Shootout.count") do
      post shootouts_url, params: { shootout: {} }
    end

    assert_redirected_to shootout_url(Shootout.last)
  end

  test "should show shootout" do
    get shootout_url(@shootout)
    assert_response :success
  end

  test "should get edit" do
    get edit_shootout_url(@shootout)
    assert_response :success
  end

  test "should update shootout" do
    patch shootout_url(@shootout), params: { shootout: {} }
    assert_redirected_to shootout_url(@shootout)
  end

  test "should destroy shootout" do
    assert_difference("Shootout.count", -1) do
      delete shootout_url(@shootout)
    end

    assert_redirected_to shootouts_url
  end
end
