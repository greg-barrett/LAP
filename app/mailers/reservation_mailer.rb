class ReservationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation_mailer.create_reservation.subject
  #
  def create_reservation(reservation)
    @reservation=reservation
    @reserver=@reservation.reserver

    mail to: @reserver.email_address, subject: "Reservation at Les Abres Paresseux"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation_mailer.update_reservation.subject
  #
  def update_reservation(reservation)
    @reservation=reservation
    @reserver=@reservation.reserver
    mail to: @reserver.email_address, subject: "Reservation at Les Abres Paresseux updated"
  end
end
