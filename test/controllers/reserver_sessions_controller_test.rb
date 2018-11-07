require 'test_helper'

class ReserverSessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @john=reservers(:john)
  end

  test "Reservers can log in" do
    get new_reserver_session_path
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    assert_redirected_to @john
    follow_redirect!
    assert_template "reservers/show"
    assert_equal flash[:notice], "You are now logged in"
    assert_equal session[:reserver_id], @john.id
  end

  test "can't log in with wrong email" do
    get new_reserver_session_path
    post reserver_sessions_path, params: {email_address:"jj@gmailcom", password: "password"}
    assert_template "reserver_sessions/new"
    assert_equal flash[:alert], "Email or password is incorrect"
  end

  test "can't log in with wrong password" do
    get new_reserver_session_path
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "pass"}
    assert_template "reserver_sessions/new"
    assert_equal flash[:alert], "Email or password is incorrect"
  end

  test " loggin out clears the sessions hash" do
    get new_reserver_session_path
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    assert_equal session[:reserver_id], @john.id
    get client_logout_path
    assert_nil session[:reserver_id]
    assert_equal flash[:notice], "You have successfully logged out"
  end


  test "should get new" do
    get client_login_path
    assert_response :success
  end



end
