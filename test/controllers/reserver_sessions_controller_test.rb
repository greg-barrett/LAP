require 'test_helper'

class ReserverSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get client_login_path
    assert_response :success
  end

end
