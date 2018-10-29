require 'test_helper'

class ReserverSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get reserver_sessions_new_url
    assert_response :success
  end

end
