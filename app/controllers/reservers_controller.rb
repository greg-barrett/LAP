class ReserversController < ApplicationController
  def new
    @reservation=Reservation.new
    @reserver=Reserver.new
    @reservation.arrival_date=params[:arrival_date] if params[:arrival_date]
    @reservation.departure_date=params[:departure_date] if params[:departure_date]

  end

  def create
    @reserver= Reserver.new(reserver_params)
    @reservation=@reserver.reservations.build(party_size: params[:reserver][:reservation][:party_size], notes: params[:reserver][:reservation][:notes])
    @reservation.confirmed=true
    if !date_is_valid?(params[:reserver][:reservation]['arrival_date(1i)'], params[:reserver][:reservation]['arrival_date(2i)'], params[:reserver][:reservation]['arrival_date(3i)']) || !date_is_valid?(params[:reserver][:reservation]['departure_date(1i)'], params[:reserver][:reservation]['departure_date(2i)'], params[:reserver][:reservation]['departure_date(3i)'])
      flash.now[:alert]="One or more of your dates in not valid"
      return render :new
    else
      add_dates
    end
    reservation_number
    fee
    if @reserver.valid? && @reservation.valid?
      @reserver.save
      @reservation.save
      login
      redirect_to @reservation
    else
      flash.now[:alert]="There is a problem with the data you submitted"
      render :new
    end

  end

  def show
    @reserver=Reserver.find(params[:id])

  end

  private

  def reserver_params
    params.require(:reserver).permit(:title, :first_name, :last_name, :email_address, :email_address_confirmation, :contact_number, :id_type, :id_number, :house_number, :street_name, :city, :country, :postcode, :password, :password_confirmation)
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

  def login
    session[:reserver_id]=@reserver.id
  end
end
