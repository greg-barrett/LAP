class ReserversController < ApplicationController
  def new
    @reservation=Reservation.new
    @reserver=Reserver.new
    @reservation.arrival_date=params[:arrival_date] if params[:arrival_date]
    @reservation.departure_date=params[:departure_date] if params[:departure_date]

  end

  def create
    @reserver=Reserver.new(reserver_params)
    @reserver.save
    @reservation=@reserver.reservations.build(party_size: params[:reserver][:reservation][:party_size], notes: params[:reserver][:reservation][:notes])
    add_dates()
    reservation_number()
    @reservation.confirmed=true
    fee()
    if @reservation.save || @reserver.valid?
      redirect_to reservation_path(@reservation)
    else
      render "reservers/new"
    end
  end

  def show

  end

  private

  def reserver_params
    params.require(:reserver).permit(:title, :first_name, :last_name, :email_address, :email_address_confirmation, :contact_number, :id_type, :id_number, :house_number, :street_name, :city, :country, :postcode)
  end

  def add_dates
    @reservation.arrival_date= (params[:reserver][:reservation]['arrival_date(1i)']+ "-" + params[:reserver][:reservation]['arrival_date(2i)']+ "-" + params[:reserver][:reservation]['arrival_date(3i)']).to_date
    @reservation.departure_date= (params[:reserver][:reservation]['departure_date(1i)']+ "-" + params[:reserver][:reservation]['departure_date(2i)']+ "-" + params[:reserver][:reservation]['departure_date(3i)']).to_date
  end

  def reservation_number
    last_number=Reservation.last.reservation_number
    last_nuber= last_number.slice(3..-1).to_i
    last_nuber=last_nuber+5
    @reservation.reservation_number="LAP" + last_nuber.to_s
  end

  def fee
    @reservation.fee=(@reservation.departure_date- @reservation.arrival_date).to_i * 50
  end
end
