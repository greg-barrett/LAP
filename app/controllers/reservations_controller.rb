class ReservationsController < ApplicationController
  #before_action :check_reservation_details, only: [:show]
  def new
    @reservation=Reservation.new
    @reserver=Reserver.new
    @arrival_date= params[:arrival_date] if params[:arrivale_date]
    @departure_date= params[:departure_date] if params[:departure_date]

  end

  def edit
  end

  def update
  end

  def show
    @reservation=Reservation.find(params[:id])
  end

  def index
  end

  def destroy
  end

  def create
    @reserver=Reserver.new(reservation_params)
    @reserver.save
    @reservation=@reserver.reservation.build(reservation_params)
    add_dates()

    reservation_number()
    @reservation.confirmed=true
    fee()
    @reservation.save

  end

  private

  def reservation_params
    params.require(:reservation).permit(:party_size, :notes, reserver: [:title, :first_name, :last_name, :email_address, :email_address_confirmation, :contact_number, :id_type, :id_number, :house_number, :street_name, :city, :country, :postcode])
  end

  def arrival_date
    @reservation.arrival_date= (params[:reservation]['arrival_date(1i)']+ "-" + params[:reservation]['arrival_date(2i)']+ "-" + params[:reservation]['arrival_date(3i)']).to_date
    @reservation.departure_date= (params[:reservation]['departure_date(1i)']+ "-" + params[:reservation]['departure_date(2i)']+ "-" + params[:reservation]['departure_date(3i)']).to_date
  end

  def reservation_number
    last_number=Reservation.last.reservation_number
    last_nuber= last_number.slice(3..-1).to_i
    last_nuber=last_nuber+5
    @reservation.reservation_number="LAP" + last_nuber
  end

  def fee
    @reservation.fee=(@reservation.departure_date- @reservation.arrival_date).to_i * 50
  end

  def check_reservation_details
    @reserver=Reserver.find_by(email_address: params[:email_address])
    @reservation=Reservation.where("reservation_number== ? AND reserver_id == ?", params[:reservation_number], @reserver.id )
    if @reservation
      true
    else
      flash[:error]="Sorry we were unanle to find a reservation with #{params[:email_address]} and reservation number #{params[:reservation_number]}"
    end
  end

end
