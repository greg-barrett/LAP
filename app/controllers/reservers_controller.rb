class ReserversController < ApplicationController
  before_action :is_logged_in?, only: [:show, :edit, :update]

  def new
    if current_reserver && !is_admin?(current_reserver)
      flash[:alert]="You already have an account"
      redirect_to new_reservation_url(:reserver_id => current_reserver.id)
    end
    @reservation=Reservation.new
    @reserver=Reserver.new
    @reservation.arrival_date=params[:arrival_date] if params[:arrival_date]
    @reservation.departure_date=params[:departure_date] if params[:departure_date]

  end

  def create
    if current_reserver && !is_admin?(current_reserver)
      flash[:alert]="You already have an account"
      return redirect_to new_reservation_url(:reserver_id => current_reserver.id)
    end
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
      login unless logged_in?
      redirect_to @reservation
    else
      flash.now[:alert]="There is a problem with the data you submitted"
      render :new
    end

  end

  def show
    @reserver=Reserver.find(params[:id])
    unless is_admin?(current_reserver) || has_access?(@reserver.id)
      return redirect_to root_url
    end

    @errors= params[:errors] || []

  end

  def edit
    @reserver=Reserver.find(params[:id])
    unless is_admin?(current_reserver) || has_access?(@reserver.id)
      return redirect_to root_url
    end
  end

  def update
    @reserver=Reserver.find(params[:id])
    if !has_access?(@reserver.id)#you are not the accoutn owner
      if !is_admin?(current_reserver) #you are not an admin
        return redirect_to root_url
      else #youa are not the owner but are an admin
        if @reserver && current_reserver.authenticate(params[:reserver][:current_password]) #if admin password is correct
          @reserver.update_attributes(reserver_params)
          flash[:notice]="The client's details have been updated"
          return redirect_to @reserver
        else
          flash.now[:alert]="That password doesn't seem right"
          return render :edit
        end
      end
    else# if you are the account holder
      if @reserver && @reserver.authenticate(params[:reserver][:current_password]) #if password correct
        @reserver.update_attributes(reserver_params)
        flash[:notice]="Your details have been updated"
        return redirect_to @reserver
      else
        flash.now[:alert]="That password doesn't seem right"
        return render :edit
      end
    end
  end

  def search
    return redirect_to root_url if !is_admin?(current_reserver)

    if params[:email_address] !=""
      @reserver=Reserver.find_by(email_address: params[:email_address] )
      if @reserver
        return redirect_to @reserver
      else
        flash[:alert]="Couldn't find #{params[:email_address]}"
        return redirect_to current_reserver
      end
    else
      flash[:alert]="You must fill in the email field"
      return redirect_to current_reserver
    end
  end


  private

  def reserver_params
    params.require(:reserver).permit(:title, :first_name, :last_name, :email_address, :email_address_confirmation, :contact_number, :id_type, :id_number, :house_number, :street_name, :city, :country, :postcode, :password, :password_confirmation)
  end

#  def add_dates
  #    @reservation.arrival_date= (params[:reserver][:reservation]['arrival_date(1i)']+ "-" + params[:reserver][:reservation]['arrival_date(2i)']+ "-" + params[:reserver][:reservation]['arrival_date(3i)']).to_date
  #    @reservation.departure_date= (params[:reserver][:reservation]['departure_date(1i)']+ "-" + params[:reserver][:reservation]['departure_date(2i)']+ "-" + params[:reserver][:reservation]['departure_date(3i)']).to_date
  #end

#  def reservation_number
  #  last_number=Reservation.last.reservation_number ||"LAP00"
#    last_nuber= last_number.slice(3..-1).to_i
  #  last_nuber=last_nuber+5
#    @reservation.reservation_number="LAP" + last_nuber.to_s
#  end

#  def fee
#    @reservation.fee=(@reservation.departure_date- @reservation.arrival_date).to_i * 50
#  end

  def login
    session[:reserver_id]=@reserver.id
  end
  def logged_in?
    session[:reserver_id] != nil
  end

end
