require 'test_helper'

class ReserversControllerTest < ActionDispatch::IntegrationTest
  def setup
    @reserver= reservers(:john)
    @admin=reservers(:admin)
    @clare=reservers(:clare)
    @johns_res=reservations(:reservation1)
    @clares_res=reservations(:reservation2)
    @new_reserver_hash={"reserver" => {"title" => "Mr",
                                      "first_name" =>"new",
                                      "last_name" =>"Smith",
                                      "id_type" =>"Passport",
                                      "id_number" =>"87547e7",
                                      "contact_number" => "+445879685985",
                                      "email_address" =>"nsmith@gmail.com",
                                      "email_address_confirmation" =>"nsmith@gmail.com",
                                      "house_number" =>"12",
                                      "street_name" =>"Old Street",
                                      "city" =>"Manchester",
                                      "country" =>"UK",
                                      "postcode" =>"WF20DR",
                                      "password" =>"password",
                                      "password_confirmation" =>"password",
                                      "reservation" => {"arrival_date(1i)" => "2019",
                                      "arrival_date(2i)" => "01",
                                      "arrival_date(3i)" => "01",
                                      "departure_date(1i)" => "2019",
                                      "departure_date(2i)" => "01",
                                      "departure_date(3i)" => "07",
                                      "party_size" => "2",
                                      "notes" => "There are some notes" }}}
    @bad_party_size={"reserver" => {"title" => "Mr",
                                      "first_name" =>"new",
                                      "last_name" =>"Smith",
                                      "id_type" =>"Passport",
                                      "id_number" =>"87547e7",
                                      "contact_number" => "+445879685985",
                                      "email_address" =>"nsmith@gmail.com",
                                      "email_address_confirmation" =>"nsmith@gmail.com",
                                      "house_number" =>"12",
                                      "street_name" =>"Old Street",
                                      "city" =>"Manchester",
                                      "country" =>"UK",
                                      "postcode" =>"WF20DR",
                                      "password" =>"password",
                                      "password_confirmation" =>"password",
                                      "reservation" => {"arrival_date(1i)" => "2018",
                                      "arrival_date(2i)" => "11",
                                      "arrival_date(3i)" => "12",
                                      "departure_date(1i)" => "2018",
                                      "departure_date(2i)" => "11",
                                      "departure_date(3i)" => "18",
                                      "party_size" => "9",
                                      "notes" => "There are some notes" }}}
  @bad_dates={"reserver" => {"title" => "Mr",
                                    "first_name" =>"new",
                                    "last_name" =>"Smith",
                                    "id_type" =>"Passport",
                                    "id_number" =>"87547e7",
                                    "contact_number" => "+445879685985",
                                    "email_address" =>"nsmith@gmail.com",
                                    "email_address_confirmation" =>"nsmith@gmail.com",
                                    "house_number" =>"12",
                                    "street_name" =>"Old Street",
                                    "city" =>"Manchester",
                                    "country" =>"UK",
                                    "postcode" =>"WF20DR",
                                    "password" =>"password",
                                    "password_confirmation" =>"password",
                                    "reservation" => {"arrival_date(1i)" => "2018",
                                    "arrival_date(2i)" => "02",
                                    "arrival_date(3i)" => "30",
                                    "departure_date(1i)" => "2018",
                                    "departure_date(2i)" => "03",
                                    "departure_date(3i)" => "05",
                                    "party_size" => "2",
                                    "notes" => "30th Feb" }}}
  @bad_email={"reserver" => {"title" => "Mr",
                                    "first_name" =>"new",
                                    "last_name" =>"Smith",
                                    "id_type" =>"Passport",
                                    "id_number" =>"87547e7",
                                    "contact_number" => "+445879685985",
                                    "email_address" =>"jjsmith@gmail.com",
                                    "email_address_confirmation" =>"jjsmith@gmail.com",
                                    "house_number" =>"12",
                                    "street_name" =>"Old Street",
                                    "city" =>"Manchester",
                                    "country" =>"UK",
                                    "postcode" =>"WF20DR",
                                    "password" =>"password",
                                    "password_confirmation" =>"password",
                                    "reservation" => {"arrival_date(1i)" => "2019",
                                    "arrival_date(2i)" => "02",
                                    "arrival_date(3i)" => "25",
                                    "departure_date(1i)" => "2019",
                                    "departure_date(2i)" => "03",
                                    "departure_date(3i)" => "05",
                                    "party_size" => "2",
                                    "notes" => "taken email address" }}}

  @overlap_dates={"reserver" => {"title" => "Mr",
                                    "first_name" =>"new",
                                    "last_name" =>"Smith",
                                    "id_type" =>"Passport",
                                    "id_number" =>"87547e7",
                                    "contact_number" => "+445879685985",
                                    "email_address" =>"nsmith@gmail.com",
                                    "email_address_confirmation" =>"nsmith@gmail.com",
                                    "house_number" =>"12",
                                    "street_name" =>"Old Street",
                                    "city" =>"Manchester",
                                    "country" =>"UK",
                                    "postcode" =>"WF20DR",
                                    "password" =>"password",
                                    "password_confirmation" =>"password",
                                    "reservation" => {"arrival_date(1i)" => "2018",
                                    "arrival_date(2i)" => "11",
                                    "arrival_date(3i)" => "10",
                                    "departure_date(1i)" => "2018",
                                    "departure_date(2i)" => "11",
                                    "departure_date(3i)" => "20",
                                    "party_size" => "2",
                                    "notes" => "Overlapping dates" }}}
end

  test "Reservation hash is valid" do
    @test_reserver=Reserver.new(title: "Mr",
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
                                            password_digest:  BCrypt::Password.create('password'))
    assert @test_reserver.valid?

    @test_reservation=Reservation.new
    @test_reservation.arrival_date= (@new_reserver_hash["reserver"]["reservation"]['arrival_date(1i)']+ "-" + @new_reserver_hash["reserver"]["reservation"]['arrival_date(2i)']+ "-" + @new_reserver_hash["reserver"]["reservation"]['arrival_date(3i)']).to_date
    @test_reservation.departure_date= (@new_reserver_hash["reserver"]["reservation"]['departure_date(1i)']+ "-" + @new_reserver_hash["reserver"]["reservation"]['departure_date(2i)']+ "-" + @new_reserver_hash["reserver"]["reservation"]['departure_date(3i)']).to_date
    @test_reservation.fee="250"
    @test_reservation.party_size="2"
    @test_reservation.reserver_id=@reserver.id
    @test_reservation.confirmed=true
    assert @test_reservation.valid?
  end

#tests after loggin in as an admin

  test "a logged in admin can access the new reserver page" do
    get client_login_path
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_redirected_to @admin
    get new_reserver_path
    assert_template "reservers/new"
    assert_nil flash[:alert]
  end

  test "logged in admin can submit to reservers/create" do
    get client_login_path
    @reservations=Reservation.count
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_difference "Reserver.count" do
      post reservers_path, params: @new_reserver_hash
     end
    assert_equal Reservation.count, @reservations+1
    follow_redirect!
    assert_select "p", {:text => "Name Mr new Smith"}
    assert_not_nil @admin.id
    assert_equal session[:reserver_id], @admin.id
  end

  test "An admin can view anyones profile" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get reserver_path(@clare)
    assert_response :success
    get reserver_path(@john)
    assert_response :success
  end

  test "An Admin can edit someones profile" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert @admin.admin
    assert_not @john.admin
    get edit_reserver_path(@john)
    assert_response :success
    patch reserver_path(@john), params: {reserver: { current_password: "password", first_name: "Changed"}}
    assert_redirected_to @john
    follow_redirect!
    assert_equal flash[:notice], "The client's details have been updated"
    assert_select "p", {:text => "Hi Changed"}
    assert_equal session[:reserver_id], @admin.id
    get edit_reserver_path(@clare)
    assert_response :success
    patch reserver_path(@clare), params: {reserver: { current_password: "password", first_name: "Claro"}}
    assert_redirected_to @clare
    follow_redirect!
    assert_equal flash[:notice], "The client's details have been updated"
    assert_select "p", {:text => "Hi Claro"}
    assert_equal session[:reserver_id], @admin.id
  end

  test "Admin is able to search by email address" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_equal session[:reserver_id], @admin.id
    get reservers_search_path, params: {email_address: @clare.email_address}
    assert_redirected_to @clare
  end

  test "If no email address is given" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_equal session[:reserver_id], @admin.id
    get reservers_search_path, params: {email_address: ""}
    assert_redirected_to @admin
    follow_redirect!
    assert_equal flash[:alert], "You must fill in the email field"
  end

  test "If no reserver is found, redirect to admin show" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_equal session[:reserver_id], @admin.id
    get reservers_search_path, params: {email_address: "mouse@gmail.com"}
    assert_redirected_to @admin
    follow_redirect!
    assert_equal flash[:alert], "Couldn't find mouse@gmail.com"
  end



# Test after loggin in as a non admin
  test " logged in reserver can't access reservers new page" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get new_reserver_path
    assert_redirected_to new_reservation_url(:reserver_id => @john.id)
  end

  test "logged in reserver user can't submit to reservers/create" do
    get client_login_path
    post reserver_sessions_path, params: {email_address:@reserver.email_address, password: "password"}
    assert_no_difference "Reserver.count" do
      post reservers_path, params: @new_reserver_hash
    end
    assert_no_difference "Reservation.count" do
      post reservers_path, params: @new_reserver_hash
    end
    follow_redirect!
    assert_equal flash[:alert], "You already have an account"
    assert_template "reservations/new"
  end

  test "reserver can view their own profile" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get reserver_path(@john)
    assert_select "p", {:text => "Hi #{@john.first_name}"}
  end

  test "A reserver can't view someone elses profile" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get reserver_path(@clare)
    assert_redirected_to root_url
  end

  test " a reserver can edit their own profile" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get edit_reserver_path(@john)
    assert_response :success
    patch reserver_path(@john), params: {reserver: { current_password: "password", first_name: "Changed"}}
    assert_redirected_to @john
    follow_redirect!
    assert_equal flash[:notice], "Your details have been updated"
    assert_select "p", {:text => "Hi Changed"}
  end

  test " a reserver cant edit someon elses profile" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get edit_reserver_path(@clare)
    assert_redirected_to root_url
    patch reserver_path(@clare), params: {reserver: { current_password: "password", first_name: "Changed"}}
    assert_redirected_to root_url
    @clare.reload
    assert_equal @clare.first_name, "Clare"
  end

  test " a reserver cant access the search feature" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get reservers_search_path, params: {email_address: @john.email_address}
    assert_redirected_to root_url
  end

#test for when no one is logged in

  test "Anyone can access reservers/new and submit if not logged in" do
    get new_reserver_path
    @reservations=Reservation.count
    assert_difference "Reserver.count" do
      post reservers_path, params: @new_reserver_hash
    end
    follow_redirect!
    assert_equal Reservation.count, @reservations+1
    assert_template "reservations/show"
    assert_not_nil session[:reserver_id]
  end

  test "Cant submit a new account if one of dates doesn't exists eg 30th Feb" do
    get new_reserver_path
    @reservations=Reservation.count
    assert_no_difference "Reserver.count" do
      post reservers_path, params: @bad_dates
    end
    assert_template "reservers/new"
    assert_equal flash[:alert], "One or more of your dates in not valid"
    assert_equal Reservation.count, @reservations
  end

  test "Cant submit a new account if reserver is invlaid" do
    get new_reserver_path
    @reservations=Reservation.count
    @john.save #create a clash witht he email address
    assert_no_difference "Reserver.count" do
      post reservers_path, params: @bad_email
    end
    assert_template "reservers/new"
    assert_equal flash[:alert], "There is a problem with the data you submitted"
    assert_equal Reservation.count, @reservations
    assert_select "p", {:text => '[:email_address, ["has already been taken"]]'}
  end

  test "Cant submit a new account if reservation is invlaid" do
    get new_reserver_path
    @reservations=Reservation.count
    assert_no_difference "Reserver.count" do
      post reservers_path, params: @bad_party_size
    end
    assert_template "reservers/new"
    assert_equal flash[:alert], "There is a problem with the data you submitted"
    assert_equal Reservation.count, @reservations
    assert_select "p", {:text => '[:"reservations.party_size", ["must be less than or equal to 6"]]'}
  end

  test "Cant submit a new account if reservation dates clash" do
    get new_reserver_path
    @reservations=Reservation.count
    @john.save
    @johns_res.save
    assert_no_difference "Reserver.count" do
      post reservers_path, params: @overlap_dates
    end
    assert_template "reservers/new"
    assert_equal flash[:alert], "There is a problem with the data you submitted"
    assert_equal Reservation.count, @reservations
    assert_select "p", {:text => '[:"reservations.arrival_date", ["It looks like those dates are already booked"]]'}

  end

  test "can't visit a profile if not logged in " do
    get reserver_path(@john)
    assert_redirected_to client_login_url
  end

  test "cant visit edit profile page if note logged in" do
    get edit_reserver_path(@john)
    assert_redirected_to client_login_url
  end

  test "cant patch a reserver if not logged in " do
    patch reserver_path(@john), params: {reserver: { current_password: "password", first_name: "Changed"}}
    assert_redirected_to client_login_url
    @john.reload
    assert_not_equal "Changed", @john.first_name
  end









end
