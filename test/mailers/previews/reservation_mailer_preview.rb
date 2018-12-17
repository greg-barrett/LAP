# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reservation_mailer/create_reservation
  def create_reservation
    reservation=Reservation.first
    ReservationMailer.create_reservation(reservation)
  end

  # Preview this email at http://localhost:3000/rails/mailers/reservation_mailer/update_reservation
  def update_reservation
    reservation=Reservation.first
    ReservationMailer.update_reservation(reservation)
  end

end
