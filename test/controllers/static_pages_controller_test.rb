require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end

  test "should get house" do
    get static_pages_house_url
    assert_response :success
  end

  test "should get location" do
    get static_pages_location_url
    assert_response :success
  end

  test "should get enquire" do
    get static_pages_enquire_url
    assert_response :success
  end

  test "should get home" do
    get static_pages_home_url
    assert_response :success
  end

end
