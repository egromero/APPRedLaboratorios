require 'test_helper'

class FlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flayer = flayers(:one)
  end

  test "should get index" do
    get flayers_url
    assert_response :success
  end

  test "should get new" do
    get new_flayer_url
    assert_response :success
  end

  test "should create flayer" do
    assert_difference('Flayer.count') do
      post flayers_url, params: { flayer: { tittle: @flayer.tittle } }
    end

    assert_redirected_to flayer_url(Flayer.last)
  end

  test "should show flayer" do
    get flayer_url(@flayer)
    assert_response :success
  end

  test "should get edit" do
    get edit_flayer_url(@flayer)
    assert_response :success
  end

  test "should update flayer" do
    patch flayer_url(@flayer), params: { flayer: { tittle: @flayer.tittle } }
    assert_redirected_to flayer_url(@flayer)
  end

  test "should destroy flayer" do
    assert_difference('Flayer.count', -1) do
      delete flayer_url(@flayer)
    end

    assert_redirected_to flayers_url
  end
end
