class ReserverSessionsController < ApplicationController
  def new
  end

  def create
    @reserver=Reserver.find_by(email_address: params[:email_address])
    if @reserver && @reserver.authenticate(params[:password])
      session[:reserver_id]=@reserver.id
      flash[:notice]="You are now logged in"
      redirect_to reserver_path(@reserver)
    else
      flash.now[:alert]="Email or password is incorrect"
      render "new"
    end
  end

  def destroy
    session[:reserver_id]=nil
    current_reserver
    flash[:notice]="You have successfully logged out"
    redirect_to root_url
  end


end
