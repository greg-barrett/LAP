require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  def setup
    @reserver = Reserver.create(first_name: "John", last_name: "Smith", email_address: "j.smith@gmail.com", email_address_confirmation: "j.smith@gmail.com",
       id_type: "Passport", id_number: "5874589658s", contact_number: "+44 7707302785", title: "Mr",
     house_number: "01 01 01", street_name: "Cliff Street", city: "Sheffield", country: "Spain", postcode: "BL0 0RY")

     @reservation = Reservation.new(arrival_date: Date.current, departure_date: Date.tomorrow, party_size: 2, confirmed: true, fee: 300.50, reserver_id: @reserver.id)

   end

  test "reservation should be valid" do
    assert @reservation.valid?
  end

  test " reservations should have a reserver" do
    assert_equal @reserver, @reservation.reserver
  end

  test "party size must be greater than 0" do
    @reservation.party_size=0
    assert_not @reservation.valid?
  end

  test "party size shouldn't be above 6" do
    @reservation.party_size=7
    assert_not @reservation.valid?
  end
  test "party size upto 6 is valid" do
    @reservation.party_size=6
    assert @reservation.valid?
  end

end
