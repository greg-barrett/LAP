require 'test_helper'

class NewReserverSignUpTest < ActionDispatch::IntegrationTest
  def setup
    @reserver= reservers(:john)
    @admin=reservers(:admin)
    @new_reserver_hash={reserver: {title: "Mr",
                                            first_name: "new",
                                            last_name: "Smith",
                                            id_type: "Passport",
                                            id_number: "87547e7",
                                            contact_number: "+445879685985",
                                            email_address: "nsmith@gmail.com",
                                            email_address_confirmation: "nsmith@gmail.com",
                                            house_number: "12",
                                            street_name: "Old Street",
                                            city: "Manchester",
                                            country: "UK",
                                            postcode: "WF20DR",
                                            password_digest: "password",
                                            admin: false,
                                            reservation: {"arrival_date(1i)" => Date.today+3.year,
                                              "arrival_date(2i)" => Date.today+3.month,
                                              "arrival_date(3i)" => Date.today+3.day,
                                              "departure_date(1i)" => Date.today+7.year,
                                              "departure_date(2i)" => Date.today+7.month,
                                              "departure_date(3i)" => Date.today+7.day,
                                              "party size" => 2,
                                              "notes" => "There are some notes" }}}
  end

  test "you cant sign up if you are logged in as a non admin" do
    get client_login_path
    post reserver_sessions_path, params: {email_address:@reserver.email_address, password: "password"}
    assert_redirected_to @reserver
    follow_redirect!
    assert_template 'reservers/show'
    get new_reserver_path
    follow_redirect!
    assert_template "reservations/new"
    assert_equal flash[:alert], "You already have an account"
  end



end
