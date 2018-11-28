class CalendarController < ApplicationController
  def index
    redirect_to calendar_url(Date.today)
  end
  def show
    cookies.encrypted[:reserver_id]=params[:reserver_id] if params[:reserver_id]
    @start_date=params[:id].to_date if params[:id]
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
        @un_availability=Reservation.where(arrival_date: @arrival_date..@departure_date).or(Reservation.where(departure_date: @arrival_date..@departure_date)).exists?
      end
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
end
