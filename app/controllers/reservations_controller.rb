class ReservationsController < ApplicationController
  before_action :is_logged_in?, only: [:show, :edit, :update, :new, :create]
  def new

    if params[:reserver_id].present?
      @reservation=Reserver.find(params[:reserver_id]).reservations.build
    else
      if is_admin?(current_reserver)
        flash[:alert]="You can create a new reservation for an existing user by first finding their profile page"
        return redirect_to current_reserver
      else
        @reservation=current_reserver.reservations.build
      end
    end
  end

  def edit
    @reservation=Reservation.find(params[:id])
    unless is_admin?(current_reserver) || has_access?(@reservation.reserver_id)
      flash[:alert]="Sorry but you don't have access to that page"
      return redirect_to root_url
    end
  end

  def update
    @reservation=Reservation.find(params[:id])
    unless is_admin?(current_reserver) || has_access?(@reservation.reserver_id)
      flash[:alert]="Sorry but you don't have access to that page"
      return redirect_to root_url
    end
    if !date_is_valid?(params[:reservation]['arrival_date(1i)'], params[:reservation]['arrival_date(2i)'], params[:reservation]['arrival_date(3i)']) || !date_is_valid?(params[:reservation]['departure_date(1i)'], params[:reservation]['departure_date(2i)'], params[:reservation]['departure_date(3i)'])
      flash.now[:alert]="One or more of your dates in not valid"
      return render :edit
    end
    if  @reservation.update_attributes(arrival_date: arrival_date, departure_date: departure_date, fee: fee, notes: params[:reservation][:notes], party_size: params[:reservation][:party_size])
      return redirect_to @reservation
      #send email confirmation
    else
      render :edit
    end

  end

  def show
    @reservation=Reservation.find(params[:id])
    unless is_admin?(current_reserver) || has_access?(@reservation.reserver_id)
      return redirect_to root_url
    end
  end

  def index
    @reserver=Reserver.find(params[:reserver_id])
    unless is_admin?(current_reserver) || has_access?(@reserver.id)
      return redirect_to root_url
    end

    if is_admin?(@reserver)
      @upcoming_reservations=Reservation.where("arrival_date > ?", Date.today).order("arrival_date")
      @past_reservations=Reservation.where("arrival_date < ?", Date.today).order("arrival_date")
    else
      @upcoming_reservations=@reserver.reservations.where("arrival_date > ?", Date.today).order("arrival_date")
      @past_reservations=@reserver.reservations.where("arrival_date < ?", Date.today).order("arrival_date")
    end
  end

  def destroy
  end

  def create
    @reservation=current_reserver.reservations.build(reservation_params) if !is_admin?(current_reserver)
    @reservation=Reserver.find(params[:reservation][:reserver_id]).reservations.build(reservation_params) if is_admin?(current_reserver)
    if !date_is_valid?(params[:reservation]['arrival_date(1i)'], params[:reservation]['arrival_date(2i)'], params[:reservation]['arrival_date(3i)']) || !date_is_valid?(params[:reservation]['departure_date(1i)'], params[:reservation]['departure_date(2i)'], params[:reservation]['departure_date(3i)'])
      flash.now[:alert]="One or more of your dates in not valid"
      return render :new
    else
      add_dates
    end
    reservation_number
    @reservation.fee=fee
    @reservation.confirmed=true
    if @reservation.save
      redirect_to @reservation
      #send email confirmation
    else

      render :new
    end


  end
  def search
    redirect_to root_url if !is_admin?(current_reserver)
    @errors=[]
    if params[:booking_reference] !=""
      @reservation=Reservation.find_by(reservation_number: params[:booking_reference] )
      @errors << "Couldn't find a reservation under #{params[:booking_reference]}." if !@reservation
      return redirect_to @reservation if @reservation
    end

    if params[:reservation][:arrival_date] !=""
      @reservation=Reservation.find_by(arrival_date: params[:reservation][:arrival_date] )
      date=params[:reservation][:arrival_date].to_date
      @errors << "Couldn't find a reservation starting #{date.strftime("%A %d %B %Y")}." if !@reservation
      return redirect_to @reservation if @reservation
    end

    if params[:reservation][:departure_date] !=""
      @reservation=Reservation.find_by(departure_date: params[:reservation][:departure_date] )
      date=params[:reservation][:departure_date].to_date
      @errors << "Couldn't find a reservation ending #{date.strftime("%A %d %B %Y")}." if !@reservation
      return redirect_to @reservation if @reservation
    end

    if !@errors.any?
      flash[:alert]="You must fill in one field"
      redirect_to current_reserver
    else
      flash[:alert]=@errors.join(" ")
      redirect_to reserver_path(current_reserver)
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:party_size, :notes )
  end
  def add_dates
      @reservation.arrival_date= (params[:reservation]['arrival_date(1i)']+ "-" + params[:reservation]['arrival_date(2i)']+ "-" + params[:reservation]['arrival_date(3i)']).to_date
      @reservation.departure_date= (params[:reservation]['departure_date(1i)']+ "-" + params[:reservation]['departure_date(2i)']+ "-" + params[:reservation]['departure_date(3i)']).to_date
  end
  def arrival_date
    (params[:reservation]['arrival_date(1i)']+ "-" + params[:reservation]['arrival_date(2i)']+ "-" + params[:reservation]['arrival_date(3i)']).to_date
  end
  def departure_date
    (params[:reservation]['departure_date(1i)']+ "-" + params[:reservation]['departure_date(2i)']+ "-" + params[:reservation]['departure_date(3i)']).to_date
  end
#  def reservation_number
#    last_number=Reservation.last.reservation_number
  #  last_nuber= last_number.slice(3..-1).to_i
  #  last_nuber=last_nuber+5
#    @reservation.reservation_number="LAP" + last_nuber.to_s
#  end

#  def fee
#    (departure_date - arrival_date).to_i * 50
#  end


end
