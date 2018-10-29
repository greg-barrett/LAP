require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  test "date_is_valid? should return false if date is fake" do
    assert_not date_is_valid?("31", "02", "2019")
    assert_not date_is_valid?("31", "06", "2019")
  end


  test "date_is_valid? should retrn true if date is a date" do
    assert date_is_valid?("01", "01", "2019")
  end


end
