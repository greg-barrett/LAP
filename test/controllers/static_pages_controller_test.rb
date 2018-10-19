require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get house" do
    get house_url
    assert_response :success
  end

  test "should get location" do
    get location_url
    assert_response :success
  end

  test "should get enquire" do
    get enquire_url
    assert_response :success
  end

  test "should get home" do
    get root_url
    assert_response :success
  end

end
