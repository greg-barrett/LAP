require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  def setup
    @reserver = reservers(:john)

     @reservation = Reservation.new(arrival_date: Date.tomorrow, departure_date: Date.today+6, party_size: 2, confirmed: true, fee: 300.50, reserver_id: @reserver.id)

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

  test "can't arrive during someone elses reservation" do
    @reservation.save
    a=Reservation.count
    @reservation2 = Reservation.new(arrival_date: Date.tomorrow, departure_date: Date.tomorrow+1, party_size: 4, confirmed: true, fee: 300.50, reserver_id: @reserver.id)
    @reservation2.save
    assert_equal a, Reservation.count
    assert_not @reservation2.valid?
  end
  test "can't leave during someone elses reservation" do
    @reservation.save
    a=Reservation.count
    @reservation2 = Reservation.new(arrival_date: Date.today+6, departure_date: Date.today+7, party_size: 4, confirmed: true, fee: 300.50, reserver_id: @reserver.id)
    @reservation2.save
    assert_equal a, Reservation.count
    assert_not @reservation2.valid?
  end

  test "reservations cannot be the same dates" do
    @reservation.save
    a=Reservation.count
    @reservation2= Reservation.new(arrival_date: Date.tomorrow, departure_date: Date.today+6, party_size: 2, confirmed: true, fee: 300.50, reserver_id: @reserver.id)
    @reservation2.save
    assert_equal a, Reservation.count
    assert_not @reservation2.valid?
  end

  test "New reservations cannot fully occupy another reservation" do
    @reservation.save
    a=Reservation.count
    @reservation2= Reservation.new(arrival_date: Date.tomorrow, departure_date: Date.today+5, party_size: 2, confirmed: true, fee: 300.50, reserver_id: @reserver.id)
    @reservation2.save
    assert_equal a, Reservation.count
    assert_not @reservation2.valid?
  end

  test "New reservations cannot fully encompas another reservation" do
    @reservation.save
    a=Reservation.count
    @reservation2= Reservation.new(arrival_date: Date.yesterday, departure_date: Date.today+7, party_size: 2, confirmed: true, fee: 300.50, reserver_id: @reserver.id)
    @reservation2.save
    assert_equal a, Reservation.count
    assert_not @reservation2.valid?
  end

  test "Can't save a duplicate reservation" do
    @reservation.save
    a=Reservation.count
    @reservation.save
    assert_equal a, Reservation.count
  end

  test "arrival date must not be today" do
    @reservation.arrival_date=Date.today
    assert_not @reservation.valid?
  end

  test "arrival date must not be in the past" do
    @reservation.arrival_date=Date.yesterday
    assert_not @reservation.valid?
  end
  test "arrival date must not be over one year away" do
    @reservation.arrival_date=Date.tomorrow.advance(years: 1)
    assert_not @reservation.valid?
  end

  test "Departure date must not be today" do
    @reservation.departure_date=Date.today
    assert_not @reservation.valid?
  end

  test "Departure date must not be in the past" do
    @reservation.departure_date=Date.yesterday
    assert_not @reservation.valid?
  end

  test "Departure date must not be over one year away" do
    @reservation.departure_date=Date.tomorrow.advance(years: 1)
    assert_not @reservation.valid?
  end

  test "Maximum booking length is 14 nights" do
    @reservation.arrival_date=Date.tomorrow
    @reservation.departure_date=Date.tomorrow+15
    assert_not @reservation.valid?
  end
  test "13 nights is a valid booking" do
    @reservation.arrival_date=Date.tomorrow
    @reservation.departure_date=Date.tomorrow+13
    assert @reservation.valid?
  end
  test "14 nights is a valid booking" do
    @reservation.arrival_date=Date.tomorrow
    @reservation.departure_date=Date.tomorrow+14
    assert @reservation.valid?
  end

  test "Arrival date must before the departure date" do
    @reservation.arrival_date=Date.tomorrow+2
    @reservation.departure_date=Date.tomorrow+1
    assert_not @reservation.valid?
  end

  test "You can't stay for less than 3 nights" do
    @reservation.arrival_date=Date.tomorrow
    @reservation.departure_date=Date.tomorrow+2
    assert_not @reservation.valid?
  end
  test "You can stay for 3 nights or more" do
    @reservation.arrival_date=Date.tomorrow
    @reservation.departure_date=Date.tomorrow+3
    assert @reservation.valid?
  end

end
