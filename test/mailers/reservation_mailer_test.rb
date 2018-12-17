require 'test_helper'

class ReservationMailerTest < ActionMailer::TestCase
  test "create_reservation" do
    mail = ReservationMailer.create_reservation
    assert_equal "Create reservation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "update_reservation" do
    mail = ReservationMailer.update_reservation
    assert_equal "Update reservation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
