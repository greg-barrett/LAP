require 'test_helper'

class ReserversLoginTest < ActionDispatch::IntegrationTest
  def setup
    @reserver= reservers(:john)
  end
  test "Cant log in with invlaid information" do
    get client_login_path
    assert_template "reserver_sessions/new"
    post reserver_sessions_path, params: {email_address: "    ", password: ""}
    assert_template "reserver_sessions/new"
    assert_not flash.empty?
  end

  test "Cant log without a password" do
    get client_login_path
    assert_template "reserver_sessions/new"
    post reserver_sessions_path, params: {email_address: @reserver.email_address, password: ""}
    assert_template "reserver_sessions/new"
    assert_not flash.empty?
  end

  test "Cant log without an email address" do
    get client_login_path
    assert_template "reserver_sessions/new"
    post reserver_sessions_path, params: {email_address: "", password: "password"}
    assert_template "reserver_sessions/new"
    assert_not flash.empty?
  end

  test "Cant log with incorrect password" do
    get client_login_path
    assert_template "reserver_sessions/new"
    post reserver_sessions_path, params: {email_address:@reserver.email_address, password: "wrong"}
    assert_template "reserver_sessions/new"
    assert_not flash.empty?
  end

  test "Can log in with correct credentials" do
    get client_login_path
    assert_template "reserver_sessions/new"
    post reserver_sessions_path, params: {email_address:@reserver.email_address, password: "password"}
    assert_redirected_to @reserver
    follow_redirect!
    assert_template 'reservers/show'
    assert_not flash.notice.empty?
    assert_select "a[href=?]", client_login_path, count: 0
    assert_select "a[href=?]", client_logout_path
    assert_select "a[href=?]", reserver_path(@reserver)
  end
end
