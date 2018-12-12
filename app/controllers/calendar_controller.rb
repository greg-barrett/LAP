class CalendarController < ApplicationController
  def index
    redirect_to calendar_url(Date.today)
  end
  def show

    cookies.encrypted[:reserver_id]=params[:reserver_id] if !params[:reserver_id].blank?
    if params[:id].blank?
      @start_date=Date.today
    else
      @start_date=params[:id].to_date
    end
    #find the reservations with either an arrival dat or a departure date within the current month
    reservations=Reservation.where(arrival_date: @start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week).or(Reservation.where(departure_date: @start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week))
    @occupied=occupied_dates(reservations)

    #if the user submits date to search for
    if params[:arrival_date]
      if !date_is_valid?(params[:arrival_date][:day], params[:arrival_date][:month], params[:arrival_date][:year] ) || !date_is_valid?(params[:departure_date][:day], params[:departure_date][:month], params[:departure_date][:year] )
        flash.now[:alert]="One or more of your dates in not valid"
        return render :show
      else
        @arrival_date=(params[:arrival_date][:year] + "-" + params[:arrival_date][:month] + "-" + params[:arrival_date][:day]).to_date
        @departure_date=(params[:departure_date][:year] + "-" + params[:departure_date][:month] + "-" + params[:departure_date][:day]).to_date
        @un_availability= unavailable?
      end
    end
    respond_to do |format|
      format.html
      format.js
    end

  end

  private

  def occupied_dates(reservations)
    occupied=[]
    reservations.each do |reservation|
      range=(reservation.arrival_date..reservation.departure_date).to_a
      occupied=occupied + range
    end
    return occupied
  end

  def unavailable?
    if @arrival_date > @departure_date
      return "Departure date must be after arrival date"
    elsif  @departure_date - @arrival_date <2
    return "Stays can't be less than two nights"
    elsif @arrival_date <= Date.today || @departure_date <= Date.today+1
      return "Bookings must be made one day in advance"
    elsif Reservation.where(arrival_date: @arrival_date..@departure_date).or(Reservation.where(departure_date: @arrival_date..@departure_date)).exists?
      return "Sorry those dates are unavailable"
    else
      return false
    end
  end
end
