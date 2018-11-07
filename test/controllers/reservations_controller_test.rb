require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @john= reservers(:john)
    @admin=reservers(:admin)
    @clare=reservers(:clare)
    @johns_res=reservations(:reservation1)
    @clares_res=reservations(:reservation2)
    @new_valid_reservation= {"reservation" => {"arrival_date(1i)" => "2019",
                            "arrival_date(2i)" => "01",
                            "arrival_date(3i)" => "01",
                            "departure_date(1i)" => "2019",
                            "departure_date(2i)" => "01",
                            "departure_date(3i)" => "07",
                            "party_size" => 2,
                            "notes" => "There are some notes",
                            "reserver_id" => @john.id }}
  end

  #logged in reserver test
  test "Reservers can access the new reservation page using params id" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get new_reservation_path, params: {reserver_id: @john.id}
    assert_response :success
  end

  test "Reservers can access the new reservation page without params id" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get new_reservation_path
    assert_response :success
  end


  test "reserver can access their own reservations" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get reservation_path(@johns_res)
    assert_template "reservations/show"
    assert_select "p", {:text => "Reservation number: #{@johns_res.reservation_number}"}
  end

  test "reserver can't access reservations that aren't theirs" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get reservation_path(@clares_res)
    assert_redirected_to root_url
    follow_redirect!
    assert_template "static_pages/home"
  end

  test "logged in reservers can access the edit page of their reservations" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get edit_reservation_path(@johns_res)
    assert_response :success
    assert_select "form input", {:value => @johns_res.notes}
  end

  test "logged in reservers cant access the reservation edit page if not their reservation" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    get edit_reservation_path(@clares_res)
    assert_redirected_to root_url
    follow_redirect!
    assert_equal flash[:alert], "Sorry but you don't have access to that page"
  end



  test "reservers can edit their reservations" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    patch reservation_path(@johns_res), params: { reservation: {"arrival_date(1i)" => (Date.today+22).year,
                                                 "arrival_date(2i)" => (Date.today+22).month,
                                                 "arrival_date(3i)" => (Date.today+22).day,
                                                 "departure_date(1i)" => (Date.today+27).year,
                                                 "departure_date(2i)" => (Date.today+27).month,
                                                 "departure_date(3i)" => (Date.today+27).day,
                                                 "party_size" => 2,
                                                 "notes" => "This has been updated" }}
    assert_redirected_to @johns_res
    follow_redirect!
    assert_select "p", {:text => "Arriving: #{Date.today+22}"}
  end

  test "reservers cant edit the reservations of others" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    patch reservation_path(@clares_res), params: { reservation: {"arrival_date(1i)" => (Date.today+22).year,
                                                 "arrival_date(2i)" => (Date.today+22).month,
                                                 "arrival_date(3i)" => (Date.today+22).day,
                                                 "departure_date(1i)" => (Date.today+27).year,
                                                 "departure_date(2i)" => (Date.today+27).month,
                                                 "departure_date(3i)" => (Date.today+27).day,
                                                 "party_size" => 2,
                                                 "notes" => "This has been updated" }}
    assert_redirected_to root_url
    follow_redirect!
    assert_equal flash[:alert], "Sorry but you don't have access to that page"
  end
  test "reservers cant update if dates are invalid eg 30th feb" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    patch reservation_path(@johns_res), params: { reservation: {"arrival_date(1i)" => "2019",
                                                 "arrival_date(2i)" => "02",
                                                 "arrival_date(3i)" => "30",
                                                 "departure_date(1i)" => "2019",
                                                 "departure_date(2i)" => "03",
                                                 "departure_date(3i)" => "05",
                                                 "party_size" => 2,
                                                 "notes" => "This has been updated" }}
    assert_template "reservations/edit"
    assert_equal flash[:alert], "One or more of your dates in not valid"
  end

  test "reservers cant update reservation with bad data" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    patch reservation_path(@johns_res), params: { reservation: {"arrival_date(1i)" => (Date.today+22).year,
                                                 "arrival_date(2i)" => (Date.today+22).month,
                                                 "arrival_date(3i)" => (Date.today+22).day,
                                                 "departure_date(1i)" => (Date.today+27).year,
                                                 "departure_date(2i)" => (Date.today+27).month,
                                                 "departure_date(3i)" => (Date.today+27).day,
                                                 "party_size" => 8,
                                                 "notes" => "This has been updated" }}
    assert_template "reservations/edit"
    assert_equal flash[:alert], "There is an issue with the data you submitted"
    assert_select "p", {:text => '[:party_size, ["must be less than or equal to 6"]]'}
  end

  test "Reservers can create new reservations linked to themselves" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    assert_difference "@john.reservations.count" do
      post reservations_path , params: @new_valid_reservation
    end
    @john.reload
    @john.reservations.reload
    assert_redirected_to @john.reservations.last

  end

  test "Reservers cant create new reservations linked to other reservers" do
    post reserver_sessions_path, params: {email_address:@john.email_address, password: "password"}
    johns_reservations=@john.reservations.count
    assert_no_difference "@clare.reservations.count" do
      post reservations_path , params: {"reservation" => {"arrival_date(1i)" => "2019",
                              "arrival_date(2i)" => "01",
                              "arrival_date(3i)" => "01",
                              "departure_date(1i)" => "2019",
                              "departure_date(2i)" => "01",
                              "departure_date(3i)" => "07",
                              "party_size" => 2,
                              "notes" => "There are some notes",
                              "reserver_id" => @clare.id }}
    end
    @john.reload
    @john.reservations.reload
    assert_equal johns_reservations, @john.reservations.count-1
    assert_redirected_to @john.reservations.last
  end

  test "Reservers can't use the search feature" do
    post reserver_sessions_path, params: {email_address: @john.email_address, password: "password"}
    get reservers_search_path, params: {email_address: @clare.email_address}
    assert_redirected_to root_url
  end



##logged in as an admin
  test "Admin can only acces the reservation new page with an id in params" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get new_reservation_path, params: {reserver_id: @john.id}
    assert_response :success
    get new_reservation_path
    assert_redirected_to @admin
    follow_redirect!
    assert_not_empty flash[:alert]
  end

  test "Admin cannot access new reservation page without a reserver id in params" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get new_reservation_path
    assert_redirected_to @admin
    follow_redirect!
    assert_not flash.empty?
  end

  test "Admin can access the dit page" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get edit_reservation_path(@johns_res)
    assert_template "reservations/edit"
    assert_select "form input", {:value => @johns_res.notes}
  end

  test "An Admin can upadate any reservation" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    patch reservation_path(@johns_res), params: { reservation: {"arrival_date(1i)" => (Date.today+22).year,
                                                 "arrival_date(2i)" => (Date.today+22).month,
                                                 "arrival_date(3i)" => (Date.today+22).day,
                                                 "departure_date(1i)" => (Date.today+27).year,
                                                 "departure_date(2i)" => (Date.today+27).month,
                                                 "departure_date(3i)" => (Date.today+27).day,
                                                 "party_size" => 2,
                                                 "notes" => "This has been updated" }}
    assert_redirected_to @johns_res
    follow_redirect!
    assert_select "p", {:text => "Arriving: #{Date.today+22}"}
  end

  test "Admins can see any reservation" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get reservation_path(@johns_res)
    assert_template "reservations/show"
    assert_select "p", {:text => "Arriving: #{Date.today+4}"}
  end

  test "An Admin can create a reservation for another reserver" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    assert_difference "@john.reservations.count" do
      post reservations_path , params: {"reservation" => {"arrival_date(1i)" => "2019",
                              "arrival_date(2i)" => "01",
                              "arrival_date(3i)" => "01",
                              "departure_date(1i)" => "2019",
                              "departure_date(2i)" => "01",
                              "departure_date(3i)" => "07",
                              "party_size" => 2,
                              "notes" => "There are some notes",
                              "reserver_id" => @john.id }}
      end

    assert_redirected_to @john.reservations.last
  end

  test "An admin can search for a reservation by booking reference" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get reservations_search_path, params: {booking_reference: "LAP10"}
    assert_redirected_to @johns_res
    follow_redirect!
    assert_select "p", {:text => "Reservation number: #{ @johns_res.reservation_number }" }
  end

  test "An admin can search for a reservation by arrival date" do
    post reserver_sessions_path, params: {email_address:@admin.email_address, password: "password"}
    get reservations_search_path, params: {reservation: {arrival_date: Date.today+4}}
    assert_redirected_to @johns_res
    follow_redirect!
    assert_select "p", {:text => "Arriving: #{@johns_res.arrival_date}"}
  end

  test "An admin can search for a reservation by departure date" do
    post reserver_sessions_path, params: {email_address: @admin.email_address, password: "password"}
    get reservations_search_path, params: {reservation: {departure_date: Date.today+10}}
    assert_redirected_to @johns_res
    follow_redirect!
    assert_select "p", {:text => "Departing: #{@johns_res.departure_date}"}
  end

end
